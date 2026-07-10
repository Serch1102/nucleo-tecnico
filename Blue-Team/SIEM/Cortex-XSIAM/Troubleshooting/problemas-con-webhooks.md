# Problemas con webhooks

## Checklist específico

- [ ] La URL del webhook es correcta.
- [ ] La URL no ha sido rotada o deshabilitada.
- [ ] Teams Workflow está habilitado.
- [ ] El canal Teams existe y mantiene permisos.
- [ ] El payload JSON es válido.
- [ ] El content-type esperado está configurado.
- [ ] No hay campos obligatorios vacíos.
- [ ] El webhook no devuelve error HTTP.
- [ ] No hay bloqueo de red o política.
- [ ] No se están generando duplicados.

## Errores típicos

| Problema | Qué revisar |
|---|---|
| No llegan alertas a Teams | URL, Workflow, permisos, filtro de severidad. |
| Webhook devuelve error | JSON, tamaño, formato, autenticación si aplica. |
| Falta información | Mapeo de campos en payload. |
| Llega demasiada información | Reducir campos y filtrar eventos. |
| Duplicidad | Control por alert ID/case ID. |

> [!WARNING]
> Si una URL de webhook se expone, rótala y revisa posibles usos no autorizados.

Relacionado: [[webhooks]], [[riesgos-y-controles]], [[formato-mensaje-teams]].

