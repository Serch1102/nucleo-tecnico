// Procesos usados frecuentemente en investigaciones.
// Validar campos reales antes de usar en producción.
dataset = xdr_data
| filter action_process_image_name in ("powershell.exe", "cmd.exe", "wscript.exe", "cscript.exe", "rundll32.exe", "regsvr32.exe", "mshta.exe")
| fields _time, agent_hostname, actor_effective_username, actor_process_image_name, action_process_image_name, action_process_image_command_line
| sort desc _time
| limit 100

