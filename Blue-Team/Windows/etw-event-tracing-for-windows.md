# ETW - Event Tracing for Windows

## Idea clave

**ETW (Event Tracing for Windows)** es una tecnología de Windows para capturar telemetría detallada de componentes del sistema, aplicaciones y proveedores específicos.

En un SOC, ETW ayuda a complementar los eventos clásicos de Windows y herramientas como [[conceptos-basicos-sysmon]] cuando necesitamos más detalle sobre procesos, runtime .NET, llamadas del sistema, cargas de módulos o comportamiento interno de Windows.

> [!NOTE]
> ETW no sustituye a Sysmon ni al EDR. Es una fuente adicional de visibilidad que puede ser muy útil en hunting, laboratorio, DFIR y validación de detecciones.

## Para qué sirve en SOC

| Uso | Ejemplo práctico |
|---|---|
| Procesos | Validar creación de procesos y relaciones padre-hijo |
| .NET | Observar carga de ensamblados y actividad del runtime |
| Hunting | Recoger señales que no siempre aparecen en Security Log o Sysmon |
| DFIR | Contrastar telemetría entre Sysmon, EDR y eventos de bajo nivel |
| Detección | Probar hipótesis antes de convertirlas en reglas |

## Proveedores frecuentes

| Proveedor | Qué puede aportar |
|---|---|
| `Microsoft-Windows-Kernel-Process` | Actividad de procesos a nivel de kernel |
| `Microsoft-Windows-DotNETRuntime` | Carga de ensamblados .NET, JIT y runtime |
| `Microsoft-Windows-Sysmon` | Eventos emitidos por Sysmon, si está instalado |

> [!WARNING]
> La disponibilidad, el detalle y la forma de recoger eventos ETW dependen de permisos, versión de Windows, herramienta usada y configuración del endpoint.

## Lectura para un analista SOC

ETW es útil cuando una alerta no cuadra del todo:

- El árbol de procesos parece raro.
- Sysmon muestra un padre sospechoso, pero falta contexto.
- Un proceso inesperado carga `clr.dll`, `clrjit.dll` o `mscoree.dll`.
- Hay sospecha de ejecución en memoria.
- El EDR muestra una cadena causal incompleta.

La pregunta práctica sería:

```text
¿ETW puede darme una capa más de evidencia para confirmar o descartar la hipótesis?
```

## Relación con otras notas

- [[conceptos-basicos-sysmon]]
- [[registros-eventos-windows-utiles]]
- [[04-etw-parent-pid-spoofing-y-dotnet-assemblies]]
- [[Detection-Engineering]]
- [[Windows]]

