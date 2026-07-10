# Campos importantes

Campos que conviene revisar durante una investigación.

| Categoría | Campos orientativos | Pregunta SOC |
|---|---|---|
| Tiempo | `timestamp`, `event_time`, `ingestion_time` | ¿Cuándo ocurrió y cuándo se recibió? |
| Host | `hostname`, `agent_hostname`, `endpoint_name` | ¿Qué equipo está afectado? |
| Usuario | `username`, `actor_username`, `user` | ¿Qué cuenta ejecutó la acción? |
| Proceso | `process_name`, `process_command_line`, `actor_process_image_name` | ¿Qué se ejecutó? |
| Red | `src_ip`, `dst_ip`, `dst_port`, `protocol` | ¿Con quién se comunicó? |
| Fichero | `file_name`, `file_path`, `sha256` | ¿Qué archivo intervino? |
| Caso | `case_id`, `incident_id`, `alert_id` | ¿Dónde se documenta? |

> [!WARNING]
> Los nombres anteriores son orientativos. Valida los campos reales con el explorador de datasets, presets o consultas simples en tu tenant.

## Query de descubrimiento orientativa

```xql
dataset = xdr_data
| limit 10
```

> [!TIP]
> Antes de escribir una query compleja, ejecuta una búsqueda pequeña y revisa qué campos existen realmente.

Relacionado: [[datasets-y-presets]], [[campos-comunes]], [[errores-comunes-xql]].

