# Windows

Fundamentos y notas operativas sobre seguridad, eventos y análisis de sistemas Windows en contexto Blue Team/SOC.

## Entradas

| Nota | Para qué sirve |
|---|---|
| [[conceptos-basicos-sysmon]] | Comprender qué es Sysmon, sus componentes y Event IDs básicos |
| [[etw-event-tracing-for-windows]] | Entender ETW como capa adicional de telemetría para hunting y DFIR |
| [[get-winevent]] | Consultar eventos Windows, Sysmon y archivos `.evtx` con PowerShell |
| [[registros-eventos-windows-utiles]] | Identificar Event IDs útiles durante investigaciones SOC |

## Uso en SOC

Windows genera eventos muy valiosos para investigar autenticación, cambios de cuentas, servicios, tareas programadas, actividad de red, Defender y manipulación de logs. Sysmon amplía esa visibilidad con eventos detallados de procesos, red, módulos, archivos y acceso a procesos.

Relacionado: [[conceptos-basicos-sysmon]], [[etw-event-tracing-for-windows]], [[get-winevent]], [[registros-eventos-windows-utiles]], [[SIEM]], [[modelo-osi]].
