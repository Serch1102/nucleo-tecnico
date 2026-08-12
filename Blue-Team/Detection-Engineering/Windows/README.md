# Windows Detection Engineering

Notas defensivas sobre detección e investigación de comportamientos sospechosos en Windows.

## Objetivo

Organizar conceptos prácticos para investigar:

- Carga anómala del runtime .NET en procesos poco habituales.
- Posible inyección PowerShell/C# o ejecución in-memory.
- Acceso sospechoso a `lsass.exe`.
- Credential dumping basado en comportamiento, no en nombre de herramienta.
- Relaciones padre-hijo anómalas y posible manipulación de linaje de procesos.
- Uso de ETW para complementar Sysmon en hunting y DFIR.
- Uso de `Get-WinEvent` para consultar logs Windows, Sysmon, ETW y `.evtx`.
- Comparativa práctica entre `Get-WinEvent`, ETW, Sysmon y SilkETW.
- Equivalencias entre Trend Micro Vision One, Cortex XSIAM/XDR y Microsoft Sentinel.

> [!WARNING]
> El objetivo no es aprender ataque ofensivo. Esta carpeta está enfocada en detección, investigación, triage y documentación SOC.

## Orden recomendado

1. [[00-managed-vs-native-code]]
2. [[01-deteccion-dotnet-runtime-anomalo]]
3. [[02-deteccion-credential-dumping-lsass]]
4. [[03-equivalencias-tmv1-cortex-sentinel]]
5. [[04-etw-parent-pid-spoofing-y-dotnet-assemblies]]
6. [[05-comparativa-get-winevent-etw-sysmon]]

## Regla mental

```text
Proceso + Ruta + Usuario + Padre + Acción + Contexto = Veredicto
```

## Regla de fuentes de telemetría

```text
Get-WinEvent consulta eventos.
Sysmon genera eventos defensivos enriquecidos.
ETW expone telemetría profunda de Windows.
SilkETW consume ETW para capturar datos específicos.
```

Relacionado: [[Detection-Engineering]], [[Windows]], [[SIEM]], [[Cortex-XSIAM]], [[etw-event-tracing-for-windows]], [[conceptos-basicos-sysmon]], [[Get-WinEvent]].
