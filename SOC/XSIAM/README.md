# Cortex XSIAM

Base de conocimiento práctica sobre Cortex XSIAM para analistas SOC junior e intermedios.

Esta sección de `nucleo-tecnico` está pensada para aprender rápido, operar mejor y documentar decisiones reales durante el análisis de alertas, cases e incidents en Cortex XSIAM/XSOAR.

> [!NOTE]
> La documentación es modular y compatible con Obsidian. Usa enlaces internos como [[que-es-cortex-xsiam]], [[introduccion-xql]] y [[propuesta-mvp]] para construir un grafo de conocimiento técnico.

## A quién va dirigido

| Perfil | Uso recomendado |
|---|---|
| Analista SOC L1/L2 | Entender alertas, priorizar, investigar y documentar. |
| Ingeniero SOC | Diseñar queries, automatizaciones, integraciones y playbooks. |
| Responsable SOC | Revisar flujos, riesgos, controles y evolución operativa. |
| Usuario no técnico | Entender qué se notifica, por qué y qué decisión se tomó. |

## Qué contiene

- Introducción a Cortex XSIAM, XDR y XSOAR.
- Flujo operativo SOC desde ingesta hasta cierre.
- Guías prácticas de alertas, cases e incidents.
- XQL básico, datasets, presets, filtros, agregaciones y joins.
- Playbooks, triggers, branches, inputs, outputs y riesgos de automatización.
- Integraciones con Microsoft Teams, webhooks, correo y ticketing.
- MVP para envío de alertas a Teams mediante webhook.
- Casos de uso SOC: malware, PowerShell, PsExec, health alerts, identidad/cloud y FP/TP.
- Troubleshooting operativo.
- Plantillas reutilizables para análisis, notificación, cierre FP y mensajes Teams.

## Cómo usarlo

1. Empieza por [[que-es-cortex-xsiam]] y [[flujo-operativo-soc]].
2. Revisa [[anatomia-de-una-alerta]] y [[checklist-analisis-alerta]] antes de investigar.
3. Aprende XQL con [[introduccion-xql]], [[estructura-basica-query]] y [[ejemplos-practicos-xql]].
4. Avanza a [[joins-en-xql]] y [[datasets-y-presets]] cuando necesites correlacionar datos.
5. Usa [[que-es-un-playbook]] y [[evolucion-a-playbooks]] para automatizar con control.
6. Consulta [[propuesta-mvp]] para el MVP de Teams.
7. Usa las plantillas de `templates/` para documentar de forma consistente.

> [!WARNING]
> Los nombres de datasets, presets y campos pueden variar según ingesta, versión, licencia, configuración del tenant e integraciones activas. Valida siempre en el entorno real antes de producción.

## Estructura rápida

- `Introduccion/`: fundamentos y visión SOC.
- `Alertas-Casos-Incidentes/`: operación de alertas y priorización.
- `XQL/`: XQL, datasets, búsquedas prácticas y joins.
- `Playbooks/`: automatización y respuesta.
- `Integraciones/`: Teams, webhooks, correo y ticketing.
- `Teams-Webhook-MVP/`: propuesta MVP y evolución.
- `Casos-de-uso-SOC/`: casos reales de investigación.
- `Troubleshooting/`: checklist de depuración.
- `Referencias/`: glosario, fuentes y mapa de aprendizaje.
- `examples/`: ejemplos XQL, Teams y playbooks.
- `templates/`: plantillas listas para copiar y adaptar.
- `assets/diagrams/`: diagramas Mermaid.

## Principios de mantenimiento

- Documentar decisiones, no solo resultados.
- Marcar todo lo dependiente de versión, permisos o licencia.
- Mantener ejemplos como orientativos si dependen del tenant.
- Evitar secretos en el repositorio.
- Preferir plantillas simples y repetibles.

## Seguridad

> [!WARNING]
> Una URL de webhook debe tratarse como secreto. No debe subirse a GitHub, tickets, capturas públicas ni documentación compartida. Usa variables seguras, vaults o mecanismos de secrets cuando aplique.

## Estado

Versión inicial del repositorio: `0.1.0`.

Ver [[mapa-de-aprendizaje]] para el recorrido recomendado.
