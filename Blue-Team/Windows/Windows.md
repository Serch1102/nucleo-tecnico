# Windows

Nota índice para seguridad y análisis de sistemas Windows en contexto SOC.

## Entradas principales

| Nota | Uso |
|---|---|
| [[conceptos-basicos-sysmon]] | Entender qué es Sysmon y qué visibilidad aporta |
| [[etw-event-tracing-for-windows]] | Comprender ETW como fuente de telemetría avanzada |
| [[get-winevent]] | Consultar logs Windows y `.evtx` desde PowerShell |
| [[registros-eventos-windows-utiles]] | Event IDs útiles para investigación SOC |
| [[00-managed-vs-native-code]] | Base para entender señales de runtime .NET y código nativo |
| [[02-deteccion-credential-dumping-lsass]] | Investigación defensiva de acceso sospechoso a LSASS |

## Conexión con SOC

Windows conecta con [[SIEM]] porque sus eventos suelen alimentar detecciones de autenticación, persistencia, cuentas, privilegios, Defender y actividad de red.

Relacionado: [[Blue-Team]], [[Detection-Engineering]], [[conceptos-basicos-sysmon]], [[etw-event-tracing-for-windows]], [[get-winevent]], [[registros-eventos-windows-utiles]], [[SIEM]], [[Elastic]], [[Cortex-XSIAM]].
