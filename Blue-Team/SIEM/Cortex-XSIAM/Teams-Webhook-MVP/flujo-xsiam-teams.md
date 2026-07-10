# Flujo XSIAM a Teams

```mermaid
sequenceDiagram
  participant X as Cortex XSIAM
  participant W as Webhook/Workflow
  participant T as Microsoft Teams
  participant A as Analista SOC
  X->>X: Detecta alerta relevante
  X->>W: Envía payload JSON
  W->>W: Valida y formatea mensaje
  W->>T: Publica en canal SOC
  A->>X: Abre case/alerta desde link
  A->>X: Investiga y documenta cierre
```

## Pasos operativos

1. Se genera una alerta en XSIAM.
2. Se aplica filtro de severidad o criterio SOC.
3. Se envía payload al webhook.
4. Teams Workflows transforma o publica el mensaje.
5. El analista abre XSIAM desde el enlace.
6. La investigación y cierre se documentan en XSIAM.

Relacionado: [[propuesta-mvp]], [[formato-mensaje-teams]], [[problemas-con-webhooks]].

