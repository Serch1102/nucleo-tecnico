# Caso de uso SOC: PowerShell sospechoso

## Qué significa

Uso de PowerShell con parámetros, codificación, descarga remota o comportamiento asociado a técnicas ofensivas.

## Qué revisar

- Línea de comandos completa.
- Proceso padre.
- Usuario.
- Script ejecutado.
- Conexiones de red.
- Actividad posterior.

## Query útil orientativa

```xql
dataset = xdr_data
| filter action_process_image_name = "powershell.exe"
| fields _time, agent_hostname, actor_effective_username, actor_process_image_name, action_process_image_command_line
| sort desc _time
| limit 100
```

## Señales de riesgo

- `-enc`, `-encodedcommand`, `downloadstring`, `iex`, `bypass`.
- Ejecución desde Office, navegador o carpeta temporal.
- Conexión a dominios desconocidos.

## Señales de falso positivo

- Script administrativo conocido.
- Ejecución desde herramienta de gestión corporativa.
- Cambio planificado.

## Decisión recomendada

Si el comando está ofuscado, descarga contenido externo o viene de proceso padre inusual, escalar como sospechoso o True Positive según evidencia.

## Ejemplo de cierre

Se validó que PowerShell fue ejecutado por herramienta corporativa de administración con script conocido y ventana de cambio aprobada. Sin actividad de red anómala. Se clasifica como False Positive documentado.

