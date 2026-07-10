// Conexiones de red orientativas desde endpoint.
dataset = xdr_data
| filter action_remote_ip != null
| fields _time, agent_hostname, actor_effective_username, action_process_image_name, action_remote_ip, action_remote_port
| sort desc _time
| limit 100

