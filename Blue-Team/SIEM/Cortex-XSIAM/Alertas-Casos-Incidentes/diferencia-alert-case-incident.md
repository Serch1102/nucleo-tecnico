# Diferencia entre Alert, Case e Incident

| Concepto | Explicación | Ejemplo |
|---|---|---|
| Alert | Señal individual generada por una detección. | PowerShell sospechoso en un host. |
| Case | Contenedor de trabajo para agrupar alertas, evidencias y tareas. | Investigación de varias señales sobre el mismo usuario. |
| Incident | Evento de seguridad confirmado o gestionado como incidente. | Compromiso confirmado de un endpoint. |

> [!NOTE]
> La terminología exacta puede variar según producto, versión y configuración. En operación SOC, lo importante es saber si estás mirando una señal aislada o una investigación agrupada.

## Regla práctica

- Alert: "algo pasó".
- Case: "vamos a investigarlo".
- Incident: "esto requiere gestión formal de incidente o respuesta coordinada".

Relacionado: [[anatomia-de-una-alerta]], [[flujo-operativo-soc]], [[plantilla-analisis-alerta]].

