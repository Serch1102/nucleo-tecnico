# Checklist debug

## General

- [ ] Reproducir el problema con un ejemplo concreto.
- [ ] Anotar hora, alerta/case ID y usuario afectado.
- [ ] Revisar permisos.
- [ ] Revisar cambios recientes.
- [ ] Validar si el problema afecta a uno o varios casos.

## Teams/webhook

- [ ] No llegan alertas a Teams.
- [ ] Llega demasiada información.
- [ ] Falta información en el mensaje.
- [ ] Webhook devuelve error.
- [ ] Payload mal formado.
- [ ] Permisos insuficientes.
- [ ] Teams Workflow deshabilitado.
- [ ] Cambios en canales/permisos.
- [ ] Problemas de formato JSON.
- [ ] Duplicidad de alertas.

## XQL

- [ ] Dataset existe.
- [ ] Campos existen.
- [ ] Filtros no son demasiado estrictos.
- [ ] Rango temporal correcto.
- [ ] Query probada por partes.

> [!TIP]
> Documenta el resultado del debug aunque el problema se resuelva rápido. Ese registro evita repetir investigación.

Relacionado: [[problemas-con-webhooks]], [[errores-comunes-xql]], [[problemas-con-playbooks]].

