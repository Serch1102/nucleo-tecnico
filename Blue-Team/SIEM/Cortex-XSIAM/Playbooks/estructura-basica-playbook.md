# Estructura básica de playbook

```mermaid
flowchart TD
  A["Trigger: alerta/case"] --> B["Validar campos mínimos"]
  B --> C["Enriquecer entidades"]
  C --> D{"Severidad alta o crítica?"}
  D -->|Sí| E["Notificar a Teams/ticket"]
  D -->|No| F["Registrar contexto"]
  E --> G["Esperar decisión o tarea analista"]
  F --> H["Cerrar o dejar en cola"]
  G --> I["Documentar acciones"]
```

## Bloques habituales

| Bloque | Objetivo |
|---|---|
| Validación | Confirmar que existen campos mínimos. |
| Enriquecimiento | Añadir contexto de IOC, asset, usuario o reputación. |
| Decisión | Separar ramas por severidad, tipo de alerta o criticidad. |
| Notificación | Enviar mensaje a canal operativo. |
| Acción | Contener, bloquear, abrir ticket o escalar. |
| Cierre | Documentar resultado y clasificación. |

> [!TIP]
> Diseña primero el flujo manual. Automatiza después los pasos repetibles.

Relacionado: [[condiciones-y-branches]], [[notificaciones]], [[buenas-practicas]].

