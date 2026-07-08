# Plantilla propuesta MVP

## Título

MVP - Envío de alertas de Cortex XSIAM a Microsoft Teams mediante webhook

## Objetivo

Validar utilidad operativa de notificaciones en Teams sin introducir automatización compleja.

## Alcance

- 

## Fuera de alcance

- 

## Arquitectura

```mermaid
flowchart LR
  A["Cortex XSIAM"] --> B["Webhook"]
  B --> C["Teams Workflows"]
  C --> D["Canal SOC"]
```

## Campos mínimos

- Severidad
- Cliente
- Alerta
- Case/Issue ID
- Host
- Usuario
- IP origen/destino
- Resumen
- Acción esperada
- Link a XSIAM

## Riesgos y controles

| Riesgo | Control |
|---|---|
| Webhook expuesto | Tratar como secreto y rotar si se expone. |
| Ruido operativo | Filtrar por severidad/caso de uso. |
| Payload incorrecto | Validar JSON en entorno de prueba. |

## Criterios de éxito

- Notificaciones llegan correctamente.
- El formato es útil para el analista.
- El volumen no genera ruido operativo.
- Hay feedback para evolucionar a playbooks.

