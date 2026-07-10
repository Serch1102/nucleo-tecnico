# Caso de uso SOC: PsExec

## Qué significa

PsExec o herramientas similares pueden usarse para administración remota legítima o movimiento lateral malicioso.

## Qué revisar

- Usuario que ejecuta.
- Host origen y destino.
- Servicio creado.
- Proceso remoto ejecutado.
- Horario y justificación.
- Si el usuario es administrador.

## Query útil orientativa

```xql
dataset = xdr_data
| filter action_process_image_name in ("psexec.exe", "paexec.exe")
| fields _time, agent_hostname, actor_effective_username, action_process_image_name, action_process_image_command_line
| sort desc _time
| limit 100
```

## Señales de riesgo

- Uso fuera de horario.
- Usuario no habitual.
- Ejecución contra muchos hosts.
- Comandos de dumping, persistencia o desactivación de seguridad.

## Señales de falso positivo

- Administración remota documentada.
- Herramienta usada por IT.
- Ticket de cambio asociado.

## Decisión recomendada

Validar con IT si existe actividad planificada. Si no hay justificación y hay propagación, escalar como posible movimiento lateral.

## Ejemplo de cierre

Actividad validada con equipo de sistemas. PsExec usado para despliegue autorizado en ventana de mantenimiento. Sin indicadores de compromiso adicionales. Se cierra como False Positive.

