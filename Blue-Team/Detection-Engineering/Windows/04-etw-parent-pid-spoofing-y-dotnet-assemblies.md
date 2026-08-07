# ETW para detectar Parent PID Spoofing y ensamblados .NET

## Idea clave

**ETW (Event Tracing for Windows)** puede aportar visibilidad más profunda que los logs clásicos y complementar a Sysmon cuando una técnica manipula o limita lo que vemos en los eventos habituales.

En estos ejemplos se trabajan dos escenarios defensivos:

1. **Relaciones padre-hijo anómalas entre procesos**, especialmente cuando Sysmon puede mostrar un padre aparente que no refleja toda la realidad.
2. **Carga de ensamblados .NET potencialmente maliciosos**, especialmente cuando se ejecutan en memoria o en contextos poco habituales.

La regla mental es:

```text
Sysmon da una buena foto del evento.
ETW puede ayudar a ver más capas de la película.
```

---

## 1. Relaciones padre-hijo anómalas

En Windows, algunos procesos suelen tener relaciones padre-hijo esperables. Cuando aparece una relación rara, puede ser una señal de abuso.

Ejemplos investigables:

| Relación observada | Lectura SOC |
|---|---|
| `explorer.exe -> cmd.exe` | Puede ser normal si el usuario abre consola |
| `winword.exe -> powershell.exe` | Sospechoso si viene de documento o macro |
| `spoolsv.exe -> whoami.exe` | Muy raro para un servicio de impresión |
| `spoolsv.exe -> cmd.exe` | Relación padre-hijo anómala |
| `calc.exe -> cmd.exe` | Poco habitual en entorno normal |

### Por qué importa

Los atacantes pueden intentar manipular la relación padre-hijo mediante técnicas como **Parent PID Spoofing**. En ese caso, una herramienta como Sysmon puede registrar que el proceso padre de `cmd.exe` es `spoolsv.exe`, aunque realmente la creación haya sido impulsada por otro proceso, por ejemplo `powershell.exe`.

Esto no significa que Sysmon sea inútil. Significa que para ciertas técnicas necesitamos más contexto.

---

## 2. Qué aporta ETW aquí

El proveedor ETW relevante para este escenario es:

```text
Microsoft-Windows-Kernel-Process
```

Este proveedor puede aportar más información sobre creación y actividad de procesos a nivel de kernel.

Con ETW podemos intentar responder:

```text
¿Quién creó realmente el proceso?
¿La relación padre-hijo es coherente?
¿Hay una discrepancia entre lo que muestra Sysmon y lo que revela ETW?
```

### Herramienta usada en el laboratorio

El material usa **SilkETW** para recoger eventos ETW y guardarlos en JSON:

```cmd
SilkETW.exe -t user -pn Microsoft-Windows-Kernel-Process -ot file -p C:\windows\temp\etw.json
```

### Lectura defensiva

Si Sysmon muestra:

```text
spoolsv.exe -> cmd.exe
```

pero ETW revela que la ejecución realmente vino de:

```text
powershell.exe -> cmd.exe
```

entonces tenemos una señal compatible con manipulación de linaje de procesos o técnica de evasión.

---

## 3. Cómo lo investigaría en SOC

### Checklist

- ¿Cuál es el proceso hijo?
- ¿Cuál es el proceso padre aparente?
- ¿Ese padre suele crear ese hijo?
- ¿Hay PowerShell, CMD, WMI, WinRM o PsExec cerca en la línea temporal?
- ¿El proceso tiene argumentos o aparece sin argumentos?
- ¿El usuario es interactivo, administrador o SYSTEM?
- ¿Hay actividad de red posterior?
- ¿Hay creación de archivos o modificación de registro después?
- ¿Existe discrepancia entre Sysmon, EDR y ETW?

### Conclusión tipo

```text
Se observa una relación padre-hijo anómala entre procesos. Aunque Sysmon muestra un proceso padre determinado, la telemetría ETW puede aportar contexto adicional sobre la creación real del proceso. Este comportamiento puede ser compatible con técnicas de spoofing de PPID o evasión de linaje de procesos. Se recomienda revisar timeline, usuario, comandos, host y actividad posterior.
```

---

## 4. Detección de ensamblados .NET maliciosos

Los atacantes pueden usar una estrategia tipo **Bring Your Own Land (BYOL)**: en vez de abusar solo de herramientas ya presentes en el sistema, llevan sus propias herramientas, muchas veces en **C#/.NET**, y las ejecutan en memoria.

Ejemplos de herramientas .NET habituales en entornos ofensivos:

| Herramienta | Uso habitual |
|---|---|
| `Seatbelt` | Enumeración local y privilegios |
| `SharpHound` | Recolección para BloodHound |
| `Rubeus` | Abuso Kerberos |
| `Certify` | Enumeración/abuso AD CS |
| `SafetyKatz` | Credential access / dumping |

La clave defensiva no es memorizar nombres, sino detectar comportamiento.

---

## 5. Sysmon Event ID 7 para .NET

Sysmon Event ID 7 registra:

```text
Image loaded
```

Es decir, un proceso cargó una DLL o módulo.

Para detectar posible ejecución .NET, se pueden observar DLLs como:

```text
clr.dll
clrjit.dll
mscoree.dll
```

### Interpretación

| Caso | Lectura |
|---|---|
| `powershell.exe` carga `clr.dll` | Normal en muchos contextos |
| `w3wp.exe` carga `clr.dll` | Puede ser normal en servidores web .NET |
| `spoolsv.exe` carga `clr.dll` | Raro, requiere investigación |
| `notepad.exe` carga `clr.dll` | Raro |
| proceso desconocido en `Downloads` carga `clr.dll` | Sospechoso |

### Limitación de Sysmon

Sysmon puede decirnos que un proceso cargó `clr.dll` o `mscoree.dll`, pero no siempre nos dice de forma granular **qué ensamblado .NET se cargó** o qué métodos se ejecutaron.

Por eso ETW puede aportar más detalle.

---

## 6. ETW con Microsoft-Windows-DotNETRuntime

Proveedor relevante:

```text
Microsoft-Windows-DotNETRuntime
```

Este proveedor permite observar eventos del runtime .NET, incluyendo carga de ensamblados y compilación JIT.

Ejemplo del laboratorio con SilkETW:

```cmd
SilkETW.exe -t user -pn Microsoft-Windows-DotNETRuntime -uk 0x2038 -ot file -p C:\windows\temp\etw.json
```

El valor `0x2038` apunta a un subconjunto de keywords relevantes:

| Keyword | Qué aporta |
|---|---|
| `JitKeyword` | Métodos compilados Just-In-Time |
| `InteropKeyword` | Interacción entre código gestionado y no gestionado |
| `LoaderKeyword` | Carga de ensamblados .NET |
| `NGenKeyword` | Ensamblados .NET precompilados |

### Lectura SOC

ETW puede ayudar a pasar de:

```text
Este proceso cargó clr.dll.
```

a:

```text
Este proceso cargó un ensamblado .NET concreto y ejecutó métodos concretos.
```

Eso es mucho más útil para threat hunting y DFIR.

---

## 7. Aterrizado a tus herramientas

### Microsoft Sentinel

Si tienes Sysmon o MDE, una búsqueda conceptual sería:

```kql
DeviceImageLoadEvents
| where FileName in~ ("clr.dll", "clrjit.dll", "mscoree.dll")
| where InitiatingProcessFileName !in~ ("powershell.exe", "pwsh.exe", "w3wp.exe", "msbuild.exe")
| project Timestamp, DeviceName, InitiatingProcessFileName, FileName, FolderPath, InitiatingProcessCommandLine, AccountName
```

Para relaciones padre-hijo:

```kql
DeviceProcessEvents
| where InitiatingProcessFileName in~ ("spoolsv.exe", "lsass.exe", "services.exe")
| where FileName in~ ("cmd.exe", "powershell.exe", "whoami.exe", "net.exe", "net1.exe")
| project Timestamp, DeviceName, InitiatingProcessFileName, FileName, ProcessCommandLine, AccountName
```

### Cortex XSIAM / XDR

Revisar:

- Causality chain.
- Causality Group Owner.
- Parent process.
- Child process.
- Command line.
- Module/DLL loaded, si el dataset lo permite.
- Usuario y host.
- Actividad de red posterior.
- Eventos de archivo o registro.

Ejemplo de cadena sospechosa:

```text
powershell.exe
 └── cmd.exe
```

Si la interfaz muestra que el padre aparente es un proceso raro como `spoolsv.exe`, conviene validar si hay indicios de manipulación del linaje.

### Trend Micro Vision One

Revisar en Workbench:

- Root cause process.
- Process tree.
- Observed Attack Techniques.
- MITRE mapping.
- Object/module evidence.
- Timeline.
- Response action.

Buscar nombres o técnicas asociadas a:

```text
Process injection
Suspicious process lineage
PowerShell abuse
.NET assembly execution
Defense evasion
```

---

## 8. Relación con MITRE ATT&CK

| Comportamiento | Posible técnica MITRE |
|---|---|
| Parent PID Spoofing | `T1134` / Access Token Manipulation, según contexto |
| Linaje de procesos manipulado | Defense Evasion |
| Ejecución de ensamblados .NET en memoria | Defense Evasion / Execution |
| Uso de herramientas .NET tipo Seatbelt | Discovery / Credential Access, según función |
| Carga anómala de CLR | Señal de posible execute-assembly o inyección |

> Nota: validar siempre la técnica exacta según la alerta, la herramienta y el comportamiento observado. No mapear únicamente por nombre de binario.

---

## 9. Regla mental final

```text
Padre raro + hijo sensible + sin argumentos claros = investigar
```

```text
Proceso inesperado + clr.dll/mscoree.dll + ruta rara + actividad posterior = investigar fuerte
```

Y la regla global:

```text
Proceso + Ruta + Usuario + Padre + Acción + Contexto = Veredicto
```

---

## Notas para CDSA

- No te quedes solo con el evento aislado.
- Correlaciona proceso padre, proceso hijo, usuario, host y tiempo.
- Sysmon ayuda mucho, pero no siempre cuenta toda la historia.
- ETW permite acceder a telemetría más granular.
- En detección .NET, `clr.dll`, `clrjit.dll` y `mscoree.dll` son señales útiles, no pruebas definitivas.
- En SOC real, lo importante es justificar por qué un comportamiento es anómalo para ese host y usuario.
