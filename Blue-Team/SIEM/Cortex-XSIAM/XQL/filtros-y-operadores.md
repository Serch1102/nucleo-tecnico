# Filtros y operadores

Los filtros permiten reducir el volumen y encontrar eventos relevantes.

## Operadores comunes

| Operador | Uso típico | Ejemplo orientativo |
|---|---|---|
| `=` | Igualdad exacta | `hostname = "HOST-001"` |
| `!=` | Distinto | `severity != "low"` |
| `contains` | Contiene texto | `process_command_line contains "powershell"` |
| `in` | Coincide con lista | `dst_port in (22, 3389, 445)` |
| `and` | Ambas condiciones | `hostname = "H1" and username = "u1"` |
| `or` | Una condición u otra | `process_name = "psexec.exe" or process_name = "paexec.exe"` |

> [!WARNING]
> La sintaxis exacta puede variar por contexto y versión. Valida en el editor XQL del tenant.

## Ejemplo por hostname

```xql
dataset = xdr_data
| filter agent_hostname = "HOST-001"
| fields _time, agent_hostname, actor_process_image_name, action_process_image_command_line
| sort desc _time
| limit 50
```

## Ejemplo por fichero

```xql
dataset = xdr_data
| filter action_file_name contains "invoice"
| fields _time, agent_hostname, action_file_name, action_file_path, action_file_sha256
| sort desc _time
| limit 50
```

Relacionado: [[ejemplos-practicos-xql]], [[errores-comunes-xql]].

