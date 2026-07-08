// Orientativo: buscar nombres de ficheros relacionados con uso de herramientas IA.
// Los datasets/campos reales pueden variar según proxy, navegador, CASB, EDR o logs cloud.
dataset = xdr_data
| filter action_file_name != null
| filter action_process_image_command_line contains "chatgpt" or action_process_image_command_line contains "copilot" or action_process_image_command_line contains "gemini"
| fields _time, agent_hostname, actor_effective_username, action_file_name, action_file_path, action_process_image_command_line
| sort desc _time
| limit 100

