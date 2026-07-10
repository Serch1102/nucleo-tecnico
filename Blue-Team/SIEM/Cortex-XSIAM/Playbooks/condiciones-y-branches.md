# Condiciones y branches

Una condición decide qué camino sigue el playbook.

## Ejemplos de condiciones

| Condición | Rama posible |
|---|---|
| Severidad Critical o High | Notificar a Teams y abrir ticket. |
| Host crítico | Escalar a L2/L3. |
| Usuario privilegiado | Requerir validación adicional. |
| Hash malicioso | Ejecutar contención con aprobación. |
| Campos mínimos ausentes | Crear tarea manual de revisión. |

## Buenas prácticas

- Usar condiciones simples y legibles.
- Evitar demasiadas ramas en el primer MVP.
- Documentar por qué existe cada rama.
- No ejecutar acciones destructivas sin aprobación.
- Registrar outputs importantes en el case.

> [!NOTE]
> Para un analista SOC: una rama clara evita dudas durante guardias y cambios de turno.

Relacionado: [[estructura-basica-playbook]], [[riesgos-y-controles]], [[ejemplos-playbooks]].

