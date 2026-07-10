# Webhooks

Un webhook permite enviar datos a una URL HTTP cuando ocurre un evento.

## Ventajas

- Arquitectura sencilla.
- Bajo acoplamiento.
- Rápido para validar un MVP.
- Compatible con flujos intermedios como Microsoft Teams Workflows.

## Riesgos

- La URL puede actuar como secreto.
- Payload mal formado.
- Errores HTTP.
- Cambios de permisos o canal.
- Duplicidad de eventos.
- Falta de reintentos o control de fallos.

> [!WARNING]
> La URL del webhook debe tratarse como secreto. No la incluyas en repositorios, capturas ni documentación compartida.

Relacionado: [[arquitectura-simple]], [[problemas-con-webhooks]], [[riesgos-y-controles]].

