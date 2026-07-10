# Qué es un playbook

Un playbook es un flujo automatizado o semiautomatizado que ejecuta pasos de investigación, enriquecimiento, notificación o respuesta.

## Para qué sirve

- Enriquecer alertas con información adicional.
- Notificar a Teams, correo o ticketing.
- Crear tareas para analistas.
- Ejecutar acciones de contención con aprobación.
- Estandarizar el proceso de respuesta.

## Conceptos clave

| Concepto | Explicación |
|---|---|
| Trigger | Evento que activa el playbook. |
| Task | Paso individual del flujo. |
| Branch | Rama condicional según resultado o campo. |
| Input | Dato de entrada usado por una tarea. |
| Output | Resultado generado por una tarea. |
| Enrichment | Añadir contexto como reputación, asset crítico o usuario. |
| Notification | Envío de mensaje a un canal o sistema. |

> [!WARNING]
> Automatizar respuesta sin controles puede provocar impacto operativo. Usa aprobaciones humanas para acciones sensibles.

Relacionado: [[estructura-basica-playbook]], [[condiciones-y-branches]], [[evolucion-a-playbooks]].

