# Ejemplos prácticos XQL

> [!WARNING]
> Estos ejemplos son orientativos. Valida nombres de datasets y campos en tu tenant antes de usarlos en operación.

## Buscar por hostname

```xql
dataset = xdr_data
| filter agent_hostname = "HOST-001"
| fields _time, agent_hostname, actor_effective_username, action_process_image_name, action_process_image_command_line
| sort desc _time
| limit 100
```

## Buscar por usuario

```xql
dataset = xdr_data
| filter actor_effective_username contains "jgarcia"
| fields _time, agent_hostname, actor_effective_username, action_process_image_name, action_process_image_command_line
| sort desc _time
| limit 100
```

## Procesos sospechosos

```xql
dataset = xdr_data
| filter action_process_image_name in ("powershell.exe", "cmd.exe", "wscript.exe", "cscript.exe", "rundll32.exe", "regsvr32.exe")
| fields _time, agent_hostname, actor_effective_username, action_process_image_name, action_process_image_command_line
| sort desc _time
| limit 100
```

## Conexiones de red

```xql
dataset = xdr_data
| filter action_remote_ip != null
| fields _time, agent_hostname, action_process_image_name, action_remote_ip, action_remote_port
| sort desc _time
| limit 100
```

## Ficheros subidos a IA

```xql
// Orientativo: buscar nombres de ficheros relacionados con dominios o procesos de herramientas IA.
// Validar datasets/campos reales según proxy, EDR, navegador, CASB o logs cloud.
dataset = xdr_data
| filter action_file_name != null
| filter action_process_image_command_line contains "chatgpt" or action_process_image_command_line contains "copilot"
| fields _time, agent_hostname, actor_effective_username, action_file_name, action_file_path, action_process_image_command_line
| sort desc _time
| limit 100
```

Relacionado: [[filtros-y-operadores]], [[joins-en-xql]], [[errores-comunes-xql]].

