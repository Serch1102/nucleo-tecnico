# Microsoft Teams

Microsoft Teams puede recibir notificaciones desde XSIAM mediante integraciones, webhooks o flujos de Microsoft Workflows.

## Usos SOC

- Avisar alertas High/Critical.
- Compartir resumen de case.
- Enviar solicitud de validación a un equipo.
- Coordinar escalado durante incidente.

## Recomendaciones

- Usar canales específicos por cliente, severidad o función.
- Evitar enviar payloads demasiado largos.
- Añadir link directo a XSIAM.
- Controlar duplicados.
- Proteger la URL del webhook.

> [!WARNING]
> Depende de la configuración de Microsoft Teams, Workflows, permisos del canal y políticas del tenant Microsoft 365.

Relacionado: [[propuesta-mvp]], [[formato-mensaje-teams]], [[plantilla-mensaje-teams]].

