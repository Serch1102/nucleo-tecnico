# Campos comunes

No todos los entornos tienen los mismos nombres de campo. Esta tabla sirve como guía de búsqueda.

| Necesidad | Campos orientativos |
|---|---|
| Tiempo | `_time`, `event_time`, `timestamp` |
| Host | `agent_hostname`, `hostname`, `endpoint_name` |
| Usuario | `actor_effective_username`, `username`, `user_name` |
| Proceso | `actor_process_image_name`, `action_process_image_name`, `process_name` |
| Línea de comandos | `action_process_image_command_line`, `process_command_line` |
| Fichero | `action_file_name`, `action_file_path`, `action_file_sha256` |
| Red | `action_remote_ip`, `dst_ip`, `dst_port`, `src_ip` |
| Alerta | `alert_id`, `alert_name`, `severity` |

> [!NOTE]
> Para un analista SOC: si no encuentras un campo, no concluyas que el evento no existe. Puede estar en otro dataset o con otro nombre.

## Mini-query de exploración

```xql
dataset = xdr_data
| limit 5
```

Relacionado: [[campos-importantes]], [[datasets-y-presets]].

