# Introducción a XQL

XQL es el lenguaje de consulta utilizado en Cortex para buscar, filtrar, transformar y correlacionar datos.

Sirve para responder preguntas como:

- ¿Qué procesos ejecutó este usuario?
- ¿Qué conexiones hizo este host?
- ¿Qué eventos ocurrieron cerca de una alerta?
- ¿Qué endpoints tienen actividad similar?
- ¿Puedo unir telemetría de procesos con inventario de assets?

> [!WARNING]
> Los datasets, presets y campos disponibles dependen de la ingesta, producto, versión, licencia y configuración del tenant.

## Estructura mental

1. Elige un dataset o preset.
2. Filtra por tiempo, host, usuario, IP o proceso.
3. Selecciona campos útiles.
4. Ordena o agrupa.
5. Correlaciona con joins solo cuando haga falta.

## Ejemplo básico orientativo

```xql
dataset = xdr_data
| filter agent_hostname = "HOST-001"
| fields _time, agent_hostname, actor_effective_username, actor_process_image_name, action_process_image_command_line
| sort desc _time
| limit 50
```

Relacionado: [[estructura-basica-query]], [[filtros-y-operadores]], [[joins-en-xql]].

