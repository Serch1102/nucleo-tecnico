# MVP - Envío de alertas de Cortex XSIAM a Microsoft Teams mediante webhook

## Objetivo

Validar rápidamente la utilidad operativa de recibir alertas relevantes de Cortex XSIAM en Microsoft Teams usando un webhook gestionado mediante Microsoft Teams Workflows.

## Texto base

Para una primera fase, se propone implementar una integración mediante webhook entre Cortex XSIAM y Microsoft Teams Workflows. Este enfoque permite validar rápidamente la utilidad operativa de recibir alertas relevantes en Teams, manteniendo una arquitectura sencilla, desacoplada y de bajo impacto. El MVP se centraría en confirmar que las notificaciones llegan correctamente, que el formato es útil para el analista y que el volumen de alertas no genera ruido operativo.

## Alcance

- Notificar solo alertas relevantes, por ejemplo High/Critical.
- Enviar campos mínimos accionables.
- Evitar automatizar respuesta en la primera fase.
- Medir volumen, utilidad y ruido.
- Documentar errores y mejoras.

## Fuera de alcance inicial

- Contención automática.
- Cierre automático de alertas.
- Enriquecimiento avanzado.
- Gestión completa de incidentes desde Teams.

## Beneficios

- Implementación rápida.
- Feedback operativo temprano.
- Menor complejidad inicial.
- Base para evolucionar a playbooks.

> [!WARNING]
> Depende de versión de Cortex XSIAM, permisos, licenciamiento, Microsoft Teams Workflows y políticas del tenant Microsoft 365.

Relacionado: [[arquitectura-simple]], [[flujo-xsiam-teams]], [[evolucion-a-playbooks]].

