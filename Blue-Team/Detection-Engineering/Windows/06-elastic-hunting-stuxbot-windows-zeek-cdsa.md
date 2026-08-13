# Elastic Hunting: Stuxbot, Windows logs, Sysmon y Zeek orientado a CDSA

## Objetivo

Esta nota recoge metodología práctica para hacer hunting en Elastic/Kibana usando logs Windows, Sysmon, PowerShell y Zeek.

Está pensada para dos contextos:

- práctica real de SOC / threat hunting;
- preparación del examen HTB CDSA con voucher, donde lo importante no es memorizar respuestas, sino saber encontrar evidencias en SIEM.

El caso usado como referencia es un lab tipo `Stuxbot`, donde se investiga una cadena de ataque simulada con procesos sospechosos, PowerShell en memoria, PowerView, Mimikatz, DCSync, persistencia y telemetría de red.

---

## 1. Qué es Stuxbot en el lab

En este contexto, `Stuxbot` debe entenderse como el nombre narrativo del actor/payload del laboratorio.

No hace falta memorizarlo como familia real de malware. Lo importante es reconocer la cadena de comportamiento:

```text
default.exe
  -> script VBS
  -> PowerShell cargado en memoria
  -> PowerView para enumeración
  -> Mimikatz para credenciales
  -> DCSync contra el dominio
  -> posible movimiento lateral o persistencia
```

Regla mental:

```text
No memorices el nombre del malware. Memoriza el patrón de ataque.
```

---

## 2. Discover vs Visualize en Kibana

Para hunting normalmente usamos `Discover`, no `Visualize Library`.

| Vista | Uso |
|---|---|
| Discover | Buscar eventos, abrir documentos, revisar campos, aplicar KQL |
| Visualize / Lens | Crear gráficos, dashboards y agregaciones |

Ruta habitual:

```text
Menu lateral -> Analytics -> Discover
```

Si aparece una pantalla de gráfico con "Drop some fields here to start", estás en Visualize/Lens, no en Discover.

Para el examen CDSA, la mayoría de preguntas de hunting se resuelven desde Discover:

- buscar por KQL;
- añadir columnas;
- abrir documentos;
- copiar el campo exacto solicitado.

---

## 3. Data views / index patterns importantes

| Patrón | Qué contiene | Uso principal |
|---|---|---|
| `windows*` | Logs Windows, Sysmon, PowerShell, Security | Proceso, usuario, comando, registro, eventos host |
| `zeek*` | Logs de red de Zeek | Conexiones, DNS, HTTP, SMB, archivos, certificados |

Regla rápida:

```text
windows* = qué pasó dentro del host
zeek*    = qué conversación ocurrió en la red
```

Ejemplo:

```text
Windows/Sysmon: powershell.exe ejecutó un comando.
Zeek: 10.10.10.5 habló con 185.x.x.x por HTTPS.
```

---

## 4. Campos Windows/Sysmon útiles

| Campo | Para qué sirve |
|---|---|
| `@timestamp` | Orden cronológico |
| `host.hostname` | Equipo afectado |
| `user.name` | Usuario asociado al evento |
| `process.name` | Nombre del proceso |
| `process.command_line` | Línea de comandos completa |
| `process.args` | Argumentos del proceso |
| `process.parent.name` | Proceso padre |
| `process.parent.command_line` | Línea de comandos del padre |
| `file.name` | Nombre de archivo |
| `file.path` | Ruta completa de archivo |
| `registry.path` | Ruta de clave/valor de registro |
| `registry.value` | Nombre del valor de registro |
| `registry.data.strings` | Datos escritos en el registro |
| `powershell.file.script_block_text` | Código PowerShell observado en script block logging |
| `event.code` | Event ID normalizado |
| `event.action` | Acción normalizada |
| `winlog.event_data.*` | Campos crudos del evento Windows/Sysmon |

Nota CDSA:

```text
Lee literalmente qué campo pide la pregunta.
No es lo mismo registry.value que registry.data.strings.
No es lo mismo process.name que process.command_line.
```

---

## 5. Campos Zeek útiles

Zeek es una herramienta de monitoreo de seguridad de red. En Elastic suele estar bajo `zeek*`.

Zeek no suele decir qué proceso generó el tráfico. Dice qué comunicación ocurrió.

| Log/dataset | Qué aporta |
|---|---|
| `zeek.conn` | Conexiones: IP origen/destino, puertos, bytes, duración |
| `zeek.dns` | Consultas DNS |
| `zeek.http` | Peticiones HTTP, URI, método, user-agent |
| `zeek.ssl` / `zeek.x509` | TLS y certificados |
| `zeek.files` | Archivos observados en red |
| `zeek.smb_files` | Archivos accedidos vía SMB |
| `zeek.smb_mapping` | Shares SMB mapeados |
| `zeek.notice` | Avisos/anomalías de Zeek |

Campos típicos:

```text
source.ip
destination.ip
source.port
destination.port
network.protocol
event.dataset
dns.question.name
url.original
http.request.method
user_agent.original
file.name
file.hash.sha256
zeek.session_id
```

Queries rápidas:

```kql
_index: zeek*
```

```kql
_index: zeek* and event.dataset:zeek.dns
```

```kql
_index: zeek* and event.dataset:zeek.http
```

```kql
_index: zeek* and destination.ip:"1.2.3.4"
```

```kql
_index: zeek* and event.dataset:zeek.smb_files
```

Regla mental:

```text
Sysmon/Windows te da proceso, usuario y comando.
Zeek te da conversación de red.
Elastic te permite cruzar ambas visiones.
```

---

## 6. Hunt: Lateral Tool Transfer a C:\Users\Public

MITRE: `T1570 - Lateral Tool Transfer`.

Objetivo: encontrar herramientas copiadas o transferidas a una ruta típica de staging.

Ruta sospechosa:

```text
C:\Users\Public
```

KQL inicial:

```kql
file.path : "C:\\Users\\Public\\*"
```

Si la pregunta dice que la herramienta empieza por `r`:

```kql
file.path : "C:\\Users\\Public\\*" and file.name : r*
```

Para ejecutables:

```kql
file.path : "C:\\Users\\Public\\*" and file.name : r*.exe
```

Columnas recomendadas:

```text
@timestamp
user.name
host.hostname
file.name
file.path
process.name
process.command_line
event.action
```

Punto CDSA:

```text
Si la pregunta pide user.name, la respuesta es el usuario del documento, no el nombre de la herramienta.
```

Herramientas que pueden aparecer y empezar por `r`:

```text
rubeus.exe
```

No responder por intuición. Abrir documento y copiar el campo exacto.

---

## 7. Hunt: Registry Run Keys / Startup Folder

MITRE: `T1547.001 - Boot or Logon Autostart Execution: Registry Run Keys / Startup Folder`.

Objetivo: encontrar persistencia mediante claves de ejecución automática.

Run Keys habituales:

```text
HKCU\Software\Microsoft\Windows\CurrentVersion\Run
HKLM\Software\Microsoft\Windows\CurrentVersion\Run
HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce
HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce
```

KQL recomendado:

```kql
event.category : registry and registry.path : *\\Software\\Microsoft\\Windows\\CurrentVersion\\Run*
```

Más completo:

```kql
event.category : registry and (
  registry.path : *\\Software\\Microsoft\\Windows\\CurrentVersion\\Run* or
  registry.path : *\\Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce*
)
```

Búsquedas alternativas:

```kql
"CurrentVersion\\Run"
```

```kql
"RunOnce"
```

Columnas útiles:

```text
@timestamp
user.name
host.hostname
process.name
process.command_line
registry.path
registry.key
registry.value
registry.data.strings
event.action
```

Cómo responder preguntas de examen:

1. filtrar Run/RunOnce;
2. ordenar `@timestamp` ascendente;
3. abrir el primer documento de persistencia real;
4. copiar exactamente el campo solicitado.

Ejemplo:

```text
TargetObject: ...\CurrentVersion\Run\ybZishBHbRKgfe
Details: C:\Users\svc-sql1\AppData\Local\Temp\svchost.exe
```

Interpretación:

```text
registry.value        = ybZishBHbRKgfe
registry.data.strings = C:\Users\svc-sql1\AppData\Local\Temp\svchost.exe
```

Error común:

```text
Confundir el nombre del valor con el ejecutable configurado para persistir.
```

---

## 8. Hunt: Mimikatz y DCSync

Objetivo: identificar ejecución de Mimikatz y argumentos usados.

KQL inicial:

```kql
process.name:"mimikatz.exe"
```

Alternativas:

```kql
process.command_line:*mimikatz*
```

```kql
mimikatz
```

Columnas útiles:

```text
@timestamp
host.hostname
user.name
process.name
process.command_line
process.args
process.parent.name
process.parent.command_line
```

Ejemplo de `process.command_line`:

```text
.\mimikatz.exe "lsadump::dcsync /domain:eagle.local /all /csv" exit
```

Si la pregunta pide "what is after .\mimikatz.exe", la respuesta sería:

```text
"lsadump::dcsync /domain:eagle.local /all /csv" exit
```

Si no acepta comillas:

```text
lsadump::dcsync /domain:eagle.local /all /csv exit
```

Interpretación SOC:

```text
mimikatz.exe + lsadump::dcsync = intento de extracción de secretos del dominio.
```

MITRE relacionado:

```text
T1003.006 - OS Credential Dumping: DCSync
```

Nota CDSA:

```text
Cuando pregunten por argumentos, mirar process.command_line o process.args.
No responder con el nombre del proceso si piden lo que va después del ejecutable.
```

---

## 9. Hunt: PowerShell en memoria y PowerView

Objetivo: identificar código PowerShell cargado en memoria que escanea o apunta a shares de red.

Pista típica del lab:

```text
Answer format: P____V___
```

Respuesta conceptual:

```text
PowerView
```

PowerView es una herramienta PowerShell popular para enumeración de Active Directory.

Funciones que delatan PowerView:

```text
Invoke-ShareFinder
Find-DomainShare
Get-NetShare
Get-DomainComputer
Get-NetComputer
```

KQL recomendado:

```kql
PowerView
```

```kql
Invoke-ShareFinder
```

```kql
Find-DomainShare
```

```kql
powershell.file.script_block_text:*share*
```

```kql
powershell.file.script_block_text:*Invoke-ShareFinder*
```

Columnas útiles:

```text
@timestamp
host.hostname
user.name
process.name
process.command_line
powershell.file.script_block_text
```

Punto importante:

```text
La pregunta no pide quién lanzó PowerShell.
Pide de qué herramienta deriva el código cargado.
```

Por tanto, no basta con mirar `process.parent.name`. Hay que revisar el contenido del script block.

---

## 10. Hunt: default.exe y scripts VBS

En algunos labs se investiga `default.exe` y se menciona un archivo VBS auxiliar.

KQL inicial:

```kql
process.name:"default.exe"
```

Alternativas:

```kql
default.exe
```

```kql
.vbs
```

```kql
process.command_line:*vbs*
```

Columnas recomendadas:

```text
@timestamp
host.hostname
user.name
process.name
process.command_line
process.parent.name
file.name
file.path
```

Objetivo:

```text
Encontrar el nombre completo del archivo .vbs mencionado en los eventos relacionados con default.exe.
```

Nota CDSA:

```text
Si piden "full name including extension", copiar solo el nombre con .vbs, no la ruta completa, salvo que la pregunta pida path.
```

---

## 11. Error común: 4624 después de LSASS dump

Un evento `4624` significa:

```text
An account was successfully logged on
```

Pero no significa automáticamente:

```text
Login malicioso confirmado
```

Después de un LSASS dump, es lógico revisar logons posteriores, pero hay que interpretar contexto.

Campos clave de 4624:

```text
TargetUserName
TargetDomainName
LogonType
IpAddress
WorkstationName
AuthenticationPackageName
LogonProcessName
```

Tipos de logon importantes:

| LogonType | Significado |
|---:|---|
| 2 | Interactive / local |
| 3 | Network |
| 5 | Service |
| 10 | RemoteInteractive / RDP |

Regla mental:

```text
4624 después de LSASS dump != login malicioso confirmado.
4624 sospechoso después de LSASS dump + usuario/IP/tipo anómalo = investigar.
```

Para contestar `Yes` en un lab, buscaría evidencia de:

- usuario inesperado;
- IP origen externa o rara;
- LogonType 3 o 10;
- NTLM o patrón de movimiento lateral;
- tiempo posterior al dump;
- relación con credenciales comprometidas.

Si solo hay logons normales de sistema/servicio/usuario esperado, no se debe marcar como malicioso.

---

## 12. Método CDSA para preguntas de hunting

Cuando una pregunta del examen diga "examine the logs" o "leverage available logs", aplicar este flujo:

```text
1. Identificar técnica MITRE o comportamiento.
2. Identificar índice/data view correcto.
3. Buscar primero amplio.
4. Añadir columnas útiles.
5. Ordenar por @timestamp si pregunta por primera/última acción.
6. Abrir documento.
7. Copiar exactamente el campo solicitado.
8. Validar si el campo es ECS o winlog.event_data.
```

Ejemplo de interpretación:

| Pregunta pide | Campo probable |
|---|---|
| usuario | `user.name` |
| proceso | `process.name` |
| argumentos | `process.args` o parte de `process.command_line` |
| comando completo | `process.command_line` |
| valor de registro | `registry.value` |
| datos de registro | `registry.data.strings` |
| ruta de archivo | `file.path` |
| nombre de archivo | `file.name` |
| script PowerShell | `powershell.file.script_block_text` |
| IP destino | `destination.ip` |
| dominio DNS | `dns.question.name` |

---

## 13. Checklist de examen CDSA

Antes de responder:

- ¿Estoy en `Discover` y no en `Visualize`?
- ¿El rango temporal cubre todos los datos? Ejemplo: `Last 15 years` si es lab histórico.
- ¿Estoy en el data view correcto? `windows*` o `zeek*`.
- ¿He abierto el documento y visto el campo exacto?
- ¿La pregunta pide nombre, ruta, argumento o valor?
- ¿Hay diferencia entre campo normalizado ECS y campo crudo `winlog.event_data.*`?
- ¿He ordenado por tiempo si dice primera/última acción?
- ¿Estoy respondiendo con el formato exacto?

Regla final:

```text
En CDSA no gana quien sabe más nombres de herramientas.
Gana quien encuentra evidencia, entiende campos y no confunde contexto con conclusión.
```

---

## 14. Reglas mentales finales

```text
Discover = hunting y documentos.
Visualize = gráficos.
```

```text
windows* = proceso, usuario, comando, registro.
zeek* = red, DNS, HTTP, SMB, archivos.
```

```text
PowerView se reconoce por funciones PowerShell de enumeración AD/shares.
Mimikatz se reconoce por process.command_line y argumentos como lsadump::dcsync.
Run Keys se reconocen por CurrentVersion\Run y CurrentVersion\RunOnce.
Lateral Tool Transfer se reconoce por herramientas copiadas a rutas de staging como C:\Users\Public.
```

```text
Proceso + Usuario + Comando + Ruta + Tiempo + Fuente = Veredicto.
```
