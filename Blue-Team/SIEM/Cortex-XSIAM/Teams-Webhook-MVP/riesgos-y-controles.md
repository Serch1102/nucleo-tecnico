# Riesgos y controles

| Riesgo | Impacto | Control |
|---|---|---|
| Webhook expuesto | Envío no autorizado de mensajes. | Tratar URL como secreto y rotarla si se expone. |
| Demasiado ruido | Fatiga de alertas. | Filtrar por severidad y casos de uso. |
| Payload mal formado | Fallo de entrega. | Validar JSON en canal de pruebas. |
| Falta información | Analista no puede actuar. | Definir campos mínimos. |
| Duplicados | Confusión operativa. | Añadir control por alert ID/case ID si aplica. |
| Permisos cambiados | Notificaciones dejan de llegar. | Revisar propietarios de Workflow y canal. |
| Datos sensibles | Exposición innecesaria. | Minimizar payload y revisar clasificación. |

> [!NOTE]
> Para usuario no técnico: el objetivo no es recibir más alertas, sino recibir mejores alertas en el lugar correcto.

Relacionado: [[checklist-debug]], [[problemas-con-webhooks]], [[evolucion-a-playbooks]].

