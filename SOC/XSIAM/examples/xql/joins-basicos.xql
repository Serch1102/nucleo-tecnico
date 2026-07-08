// Join básico orientativo: procesos sospechosos con conexiones de red del mismo host.
// Ajustar datasets/campos según versión, licencia e ingesta del tenant.
config timeframe = 1 d
| dataset = xdr_data
| filter agent_hostname != null and agent_hostname != ""
| filter action_process_image_name in ("powershell.exe", "cmd.exe", "mshta.exe")
| alter join_host = lowercase(agent_hostname)
| fields _time, join_host, agent_hostname, actor_effective_username, action_process_image_name, action_process_image_command_line
| join type = left conflict_strategy = left (
    dataset = xdr_data
    | filter agent_hostname != null and agent_hostname != ""
    | filter action_remote_ip != null and action_remote_ip != ""
    | alter net_join_host = lowercase(agent_hostname)
    | fields net_join_host, action_remote_ip, action_remote_port
  ) as net net.net_join_host = join_host
| fields _time, agent_hostname, actor_effective_username, action_process_image_name, action_process_image_command_line, action_remote_ip, action_remote_port
| sort desc _time
| limit 100
