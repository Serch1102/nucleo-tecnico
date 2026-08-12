# Comparativa práctica: Get-WinEvent, ETW y Sysmon

## Objetivo

Esta nota resume y compara tres piezas importantes de telemetría Windows para investigación SOC, threat hunting y preparación CDSA:

- [[get-winevent]]
- [[etw-event-tracing-for-windows|ETW]] / Event Tracing for Windows
- [[conceptos-basicos-sysmon|Sysmon]]

La idea no es memorizarlas como herramientas sueltas, sino entender cómo se complementan cuando investigamos procesos, DLLs, conexiones, PowerShell, .NET, LSASS o eventos exportados `.evtx`.

> [!NOTE]
> Esta entrada es una comparativa práctica. Para profundizar en cada fuente, salta a [[get-winevent]], [[etw-event-tracing-for-windows]] y [[conceptos-basicos-sysmon]].

---

## Resumen ejecutivo

| Elemento | Qué es | Para qué lo uso en SOC |
|---|---|---|
| `Get-WinEvent` | Cmdlet de PowerShell para consultar logs Windows, Sysmon, ETW y `.evtx` | Buscar, filtrar, automatizar y pivotar sobre eventos |
| `ETW` | Infraestructura interna de tracing de Windows | Obtener telemetría profunda del sistema operativo y runtimes como .NET |
| `Sysmon` | Herramienta de Microsoft Sysinternals que genera eventos defensivos enriquecidos | Registrar creación de procesos, conexiones, DLLs, acceso a procesos, etc. |

Regla rápida:

```text
Event Viewer = mirar eventos
Get-WinEvent = consultar y filtrar eventos con PowerShell
Sysmon = generar mejores eventos defensivos
ETW = fuente profunda de telemetría interna de Windows
```

---

## 1. Get-WinEvent

`Get-WinEvent` es un cmdlet de PowerShell para consultar eventos de Windows de forma masiva.

Sirve para leer:

- logs clásicos: `Security`, `System`, `Application`;
- logs modernos `.evtx`;
- logs de Sysmon;
- logs de PowerShell;
- logs operacionales como WinRM, WMI, OpenSSH;
- archivos `.evtx` exportados.

### Uso base

```powershell
Get-WinEvent -LogName 'System' -MaxEvents 50 |
Select-Object TimeCreated, Id, ProviderName, LevelDisplayName, Message |
Format-Table -AutoSize
```

Traducción:

> Dame los últimos 50 eventos del log `System` y muéstrame campos útiles.

### Listar logs disponibles

```powershell
Get-WinEvent -ListLog * |
Select-Object LogName, RecordCount, IsClassicLog, IsEnabled, LogMode, LogType |
Format-Table -AutoSize
```

Esto permite saber qué logs existen, si están habilitados y cuántos eventos contienen.

### Listar proveedores

```powershell
Get-WinEvent -ListProvider * | Format-Table -AutoSize
```

Un provider es la fuente que genera eventos. Ejemplos:

```text
Microsoft-Windows-Sysmon
Microsoft-Windows-Security-Auditing
Microsoft-Windows-WinRM
Microsoft-Windows-PowerShell
```

### Leer un archivo `.evtx`

```powershell
Get-WinEvent -Path 'C:\Ruta\archivo.evtx' -MaxEvents 5 |
Select-Object TimeCreated, Id, ProviderName, LevelDisplayName, Message |
Format-Table -AutoSize
```

Esto es clave en DFIR/labs porque permite analizar logs exportados de otro equipo sin depender del Event Viewer.

### Filtrar con FilterHashtable

```powershell
Get-WinEvent -FilterHashtable @{
  LogName='Microsoft-Windows-Sysmon/Operational'
  Id=1,3
} |
Select-Object TimeCreated, Id, ProviderName, Message |
Format-Table -AutoSize
```

Ejemplo SOC:

- Sysmon ID `1` = process creation.
- Sysmon ID `3` = network connection.

Si un proceso se crea y poco después conecta a una IP externa rara, puede ser un indicio de C2 o ejecución sospechosa.

### Filtrar por fechas

```powershell
$startDate = (Get-Date -Year 2023 -Month 5 -Day 28).Date
$endDate   = (Get-Date -Year 2023 -Month 6 -Day 3).Date

Get-WinEvent -FilterHashtable @{
  LogName='Microsoft-Windows-Sysmon/Operational'
  Id=1,3
  StartTime=$startDate
  EndTime=$endDate
}
```

Nota: normalmente `EndTime` actúa como límite superior. Para incluir un día completo, se suele poner como final el día siguiente.

### Extraer campos XML de eventos

Muchos eventos guardan los campos importantes dentro del XML.

Ejemplo para conexiones Sysmon ID 3 hacia una IP concreta:

```powershell
Get-WinEvent -FilterHashtable @{
  LogName='Microsoft-Windows-Sysmon/Operational'
  Id=3
} |
ForEach-Object {
  $xml = [xml]$_.ToXml()
  $eventData = $xml.Event.EventData.Data

  [PSCustomObject]@{
    SourceIP      = ($eventData | Where-Object {$_.Name -eq 'SourceIp'} | Select-Object -ExpandProperty '#text')
    DestinationIP = ($eventData | Where-Object {$_.Name -eq 'DestinationIp'} | Select-Object -ExpandProperty '#text')
    ProcessGuid   = ($eventData | Where-Object {$_.Name -eq 'ProcessGuid'} | Select-Object -ExpandProperty '#text')
    ProcessId     = ($eventData | Where-Object {$_.Name -eq 'ProcessId'} | Select-Object -ExpandProperty '#text')
  }
} |
Where-Object {$_.DestinationIP -eq '52.113.194.132'}
```

La gracia es pivotar después por `ProcessGuid` o `ProcessId` para saber qué proceso hizo la conexión.

### Buscar PowerShell encoded command

```powershell
Get-WinEvent -FilterHashtable @{
  LogName='Microsoft-Windows-Sysmon/Operational'
  Id=1
} |
Where-Object {$_.Properties[21].Value -like '*-enc*'} |
Format-List
```

En el ejemplo del módulo, `Properties[21]` corresponde a `ParentCommandLine` en eventos Sysmon ID 1.

`-enc` suele relacionarse con `-EncodedCommand`, muy usado para ofuscar comandos PowerShell.

> [!WARNING]
> En el ejemplo anterior, `Properties[21]` procede de un caso concreto de Sysmon ID 1. Antes de usarlo en otro entorno, valida el XML del evento con `ToXml()` y confirma qué campo ocupa cada posición.

---

## 2. Sysmon

Sysmon es una herramienta de Microsoft Sysinternals que se instala en Windows para generar eventos más ricos para detección.

No sustituye a los logs nativos. Los complementa.

> [!NOTE]
> La visibilidad de Sysmon depende de que esté instalado, activo y configurado correctamente. No todos los entornos registran los mismos Event IDs.

### Eventos Sysmon útiles

| Event ID | Nombre | Uso SOC |
|---:|---|---|
| 1 | Process Create | Ver procesos, línea de comandos, padre, usuario, hash |
| 3 | Network Connection | Ver conexiones de red iniciadas por procesos |
| 7 | Image Loaded | Ver DLLs/módulos cargados por procesos |
| 10 | Process Access | Ver acceso de un proceso a otro, útil para LSASS |
| 11 | File Create | Ver creación de archivos |
| 13 | Registry Value Set | Ver cambios en registro |
| 22 | DNS Query | Ver consultas DNS |

### Ejemplo: DLL hijacking

Para detectar DLL hijacking se suele mirar Sysmon ID `7`:

```text
Image = proceso que carga algo
ImageLoaded = DLL/módulo cargado
```

Ejemplo normal:

```text
Image: C:\Windows\System32\mmc.exe
ImageLoaded: C:\Windows\System32\psapi.dll
Signed: true
```

Ejemplo sospechoso:

```text
Image: C:\Users\Waldo\Desktop\calc.exe
ImageLoaded: C:\Users\Waldo\Desktop\WININET.dll
Signed: false
```

Regla mental:

```text
Proceso legítimo + DLL desde ruta rara + sin firma = investigar
```

### Ejemplo: ejecución .NET / C#

Sysmon ID `7` también permite ver cargas de DLL relacionadas con .NET:

```text
clr.dll
clrjit.dll
mscoree.dll
```

Si las carga `powershell.exe`, puede ser normal.

Si las carga `spoolsv.exe`, `notepad.exe`, `rundll32.exe` o un proceso raro, puede indicar ejecución .NET inusual, execute-assembly o inyección.

### Ejemplo: credential dumping

Sysmon ID `10` ayuda a detectar acceso a procesos sensibles como `lsass.exe`.

Ejemplo sospechoso:

```text
SourceImage: C:\Users\Waldo\Downloads\AgentEXE.exe
TargetImage: C:\Windows\System32\lsass.exe
```

Esto puede ser compatible con MITRE `T1003.001 - OS Credential Dumping: LSASS Memory`.

---

## 3. ETW

ETW significa `Event Tracing for Windows`.

Es una infraestructura interna de Windows para tracing de alto rendimiento. Está más abajo que muchas herramientas de log tradicionales.

> [!WARNING]
> ETW puede requerir permisos elevados y herramientas específicas para capturar o consumir determinados providers. En producción, valida impacto, permisos y retención antes de usarlo como fuente operativa.

### Componentes principales

| Componente | Explicación |
|---|---|
| Provider | Fuente que genera eventos |
| Controller | Herramienta que crea/gestiona sesiones ETW |
| Consumer | Herramienta que consume eventos |
| Session | Sesión de rastreo activa |
| ETL file | Archivo de salida de eventos ETW |

Ejemplos de providers:

```text
Microsoft-Windows-Kernel-Process
Microsoft-Windows-DotNETRuntime
Microsoft-Windows-PowerShell
Microsoft-Windows-Kernel-Network
Microsoft-Windows-DNS-Client
```

### Consultar sesiones ETW

```cmd
logman.exe query -ets
```

El parámetro `-ets` es importante porque consulta sesiones ETW activas.

### Consultar providers ETW

```cmd
logman.exe query providers
```

Filtrar providers:

```cmd
logman.exe query providers | findstr "Winlogon"
```

Ver detalles de un provider:

```cmd
logman.exe query providers Microsoft-Windows-Winlogon
```

---

## 4. SilkETW

SilkETW es una herramienta para consumir eventos ETW y guardarlos, por ejemplo, en JSON.

En los labs se usa para capturar providers concretos.

> [!NOTE]
> SilkETW se menciona como herramienta de laboratorio. En un SOC real, la forma de capturar ETW puede variar según EDR, SIEM, agente, política corporativa y permisos.

### Ejemplo: Kernel Process

```cmd
SilkETW.exe -t user -pn Microsoft-Windows-Kernel-Process -ot file -p C:\Windows\Temp\etw.json
```

Sirve para capturar telemetría de procesos desde el provider `Microsoft-Windows-Kernel-Process`.

Esto ayuda a investigar técnicas como Parent PID Spoofing, donde un árbol de procesos puede mostrar una relación padre-hijo engañosa.

Ejemplo:

```text
Vista superficial:
spoolsv.exe -> cmd.exe

Contexto real:
powershell.exe provocó la creación, pero se falseó el parent PID.
```

### Ejemplo: DotNETRuntime

```cmd
SilkETW.exe -t user -pn Microsoft-Windows-DotNETRuntime -uk 0x2038 -ot file -p C:\Windows\Temp\etw.json
```

El provider `Microsoft-Windows-DotNETRuntime` permite ver más detalle de actividad .NET.

La máscara `0x2038` enfoca eventos como:

- JIT;
- Interop;
- Loader;
- NGen.

Ejemplo con Seatbelt:

```powershell
.\Seatbelt.exe TokenPrivileges
```

Al ejecutar `Seatbelt.exe TokenPrivileges`, ETW puede registrar llamadas de interoperabilidad .NET hacia APIs nativas de Windows.

Campo relevante:

```text
ManagedInteropMethodName: GetTokenInformation
```

Explicación:

- Seatbelt está hecho en C#/.NET.
- `TokenPrivileges` consulta privilegios del token.
- Windows expone esa información mediante la API nativa `GetTokenInformation`.
- ETW lo registra como `ManagedInteropMethodName`.

---

## 5. Comparativa directa

| Pregunta SOC | Get-WinEvent | Sysmon | ETW / SilkETW |
|---|---|---|---|
| ¿Qué logs existen? | Sí | No | Parcial con `logman` |
| ¿Qué proceso se creó? | Sí, si el log existe | Sí, ID 1 | Sí, provider Kernel-Process |
| ¿Qué DLL cargó un proceso? | Sí, leyendo Sysmon ID 7 | Sí, ID 7 | Sí, con providers adecuados |
| ¿Qué proceso accedió a LSASS? | Sí, leyendo Sysmon ID 10 | Sí, ID 10 | Posible con providers avanzados |
| ¿Qué conexiones hizo un proceso? | Sí, leyendo Sysmon ID 3 | Sí, ID 3 | Sí, Kernel-Network |
| ¿Puedo leer `.evtx` exportados? | Sí | No aplica | No es su uso principal |
| ¿Puedo ver internals de .NET? | Limitado | Parcial, por DLLs cargadas | Sí, DotNETRuntime |
| ¿Sirve para automatizar hunting? | Sí | Genera datos | Sí, pero más avanzado |

---

## 6. Equivalencia con herramientas SOC

| Concepto | Microsoft Sentinel | Cortex XSIAM/XDR | Trend Micro Vision One |
|---|---|---|---|
| Proceso creado | `DeviceProcessEvents`, `SecurityEvent`, Sysmon | Process events / causality chain | Workbench process tree |
| DLL cargada | `DeviceImageLoadEvents`, Sysmon 7 | Module/Image load events si disponible | Object/module evidence |
| Conexión de red | `DeviceNetworkEvents`, Sysmon 3 | Network events | Network activity / object |
| Acceso a LSASS | Sysmon 10 / MDE events | Credential access alerts | Observed Attack Techniques |
| Relación padre-hijo | Parent process fields | Causality Group Owner / causality chain | Root cause process / process tree |
| .NET interno | Difícil salvo ETW ingest | Depende de sensor/dataset | Depende de telemetría EDR |
| Investigación manual local | `Get-WinEvent` / PowerShell | Endpoint data + XQL | Workbench + telemetry |

> [!WARNING]
> Los nombres de datasets, campos y vistas en Cortex XSIAM/XDR pueden variar según tenant, licencia, integración y producto. Validar siempre en el entorno real antes de convertir esta tabla en detección.

---

## 7. Cuándo usar cada uno

### Uso `Get-WinEvent` cuando...

- tengo un `.evtx`;
- necesito filtrar rápido por Event ID;
- quiero buscar por fecha;
- Event Viewer se queda corto;
- quiero automatizar una investigación local.

### Uso Sysmon cuando...

- necesito mejor telemetría defensiva;
- quiero ver procesos, hashes y padres;
- quiero ver DLLs cargadas;
- quiero detectar acceso a LSASS;
- quiero registrar conexiones asociadas a procesos.

### Uso ETW / SilkETW cuando...

- Sysmon no da suficiente detalle;
- quiero ver eventos más profundos;
- quiero investigar .NET internals;
- quiero estudiar parent PID spoofing;
- quiero capturar providers concretos en un lab.

---

## 8. Notas para CDSA

Para CDSA, la idea importante no es memorizar comandos aislados.

Lo importante es saber responder:

```text
¿Qué fuente de telemetría necesito?
¿Qué campo me permite pivotar?
¿Qué evento confirma la hipótesis?
¿Qué contexto reduce falsos positivos?
```

Ejemplos:

| Caso | Fuente útil | Qué revisar |
|---|---|---|
| DLL hijacking | Sysmon ID 7 | `Image`, `ImageLoaded`, ruta, firma |
| C#/.NET injection | Sysmon ID 7 + ETW DotNETRuntime | `clr.dll`, `mscoree.dll`, methods, interop |
| Credential dumping | Sysmon ID 10 | `SourceImage`, `TargetImage`, `lsass.exe`, usuario, ruta |
| Parent PID spoofing | Sysmon ID 1 + ETW Kernel-Process | Parent aparente vs telemetría real |
| C2 básico | Sysmon ID 1 + 3 | proceso creado + conexión externa |
| PowerShell ofuscado | Sysmon ID 1 / PowerShell logs | `-enc`, `EncodedCommand`, parent command line |

---

## 9. Regla mental final

```text
Get-WinEvent consulta eventos.
Sysmon genera eventos defensivos enriquecidos.
ETW expone telemetría profunda de Windows.
SilkETW consume ETW para capturar datos específicos.
```

Y para investigar:

```text
Proceso + Ruta + Usuario + Padre + Acción + Tiempo + Fuente = Veredicto
```

## Relacionado

- [[get-winevent]]
- [[conceptos-basicos-sysmon]]
- [[etw-event-tracing-for-windows]]
- [[04-etw-parent-pid-spoofing-y-dotnet-assemblies]]
- [[03-equivalencias-tmv1-cortex-sentinel]]
- [[Windows]]
- [[Detection-Engineering]]
- [[Cortex-XSIAM]]
