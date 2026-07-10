// Join avanzado orientativo: eventos endpoint con inventario de assets.
// El dataset assets_inventory y campos de criticidad son ejemplos, validar en el tenant.
config timeframe = 1 d
| dataset = xdr_data
| filter agent_hostname != null and agent_hostname != ""
| filter action_process_image_name != null
| alter join_host = lowercase(agent_hostname)
| fields _time, join_host, agent_hostname, actor_effective_username, action_process_image_name, action_process_image_command_line
| join type = left conflict_strategy = left (
    dataset = assets_inventory
    | filter hostname != null and hostname != ""
    | alter asset_join_host = lowercase(hostname)
    | dedup asset_join_host
    | fields asset_join_host, asset_criticality, business_unit, owner
  ) as asset asset.asset_join_host = join_host
| fields _time, agent_hostname, asset_criticality, business_unit, owner, actor_effective_username, action_process_image_name, action_process_image_command_line
| sort desc _time
| limit 100
