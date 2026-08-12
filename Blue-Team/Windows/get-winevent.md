# Get-WinEvent

## Idea clave

`Get-WinEvent` es un cmdlet de PowerShell para consultar eventos de Windows desde consola o scripts.

Permite leer logs activos del sistema, logs modernos `.evtx`, eventos de [[conceptos-basicos-sysmon]] y archivos exportados para análisis local o DFIR.

> [!NOTE]
> `Get-WinEvent` no genera telemetría. Consulta eventos que ya existen. La calidad del análisis depende de que el log esté habilitado, conserve datos y tenga los campos necesarios.

## Para qué sirve en SOC

| Uso | Ejemplo |
|---|---|
| Revisar logs locales | Consultar `Security`, `System` o `Application` |
| Leer `.evtx` exportados | Analizar eventos de otro host en laboratorio |
| Buscar por Event ID | Filtrar Sysmon ID `1`, `3`, `7` o `10` |
| Pivotar por tiempo | Ver qué pasó antes y después de una alerta |
| Automatizar hunting | Crear consultas repetibles con PowerShell |

## Consulta básica

```powershell
Get-WinEvent -LogName 'System' -MaxEvents 50 |
Select-Object TimeCreated, Id, ProviderName, LevelDisplayName, Message |
Format-Table -AutoSize
```

## Consulta con filtro

```powershell
Get-WinEvent -FilterHashtable @{
  LogName='Microsoft-Windows-Sysmon/Operational'
  Id=1,3
} |
Select-Object TimeCreated, Id, ProviderName, Message |
Format-Table -AutoSize
```

> [!TIP]
> Para SOC, `FilterHashtable` suele ser más limpio y eficiente que traer todos los eventos y filtrar después con `Where-Object`.

## Leer un archivo EVTX

```powershell
Get-WinEvent -Path 'C:\Ruta\archivo.evtx' -MaxEvents 10 |
Select-Object TimeCreated, Id, ProviderName, Message
```

## Precauciones

> [!WARNING]
> Algunos logs requieren permisos elevados. Si no aparecen eventos, valida permisos, nombre exacto del log, retención, rango temporal y si el canal está habilitado.

> [!WARNING]
> Evita depender de posiciones como `Properties[21]` sin validar antes el XML del evento. La posición puede cambiar según proveedor, versión, configuración o tipo de evento.

## Relación con otras notas

- [[05-comparativa-get-winevent-etw-sysmon]]
- [[conceptos-basicos-sysmon]]
- [[etw-event-tracing-for-windows]]
- [[registros-eventos-windows-utiles]]
- [[Windows]]

