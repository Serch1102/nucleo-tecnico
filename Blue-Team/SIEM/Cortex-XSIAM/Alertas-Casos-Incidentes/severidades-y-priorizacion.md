# Severidades y priorización

La severidad ayuda a decidir qué revisar primero, pero no sustituye el criterio del analista.

| Severidad | Prioridad típica | Qué validar |
|---|---|---|
| Critical | Inmediata | Impacto alto, compromiso probable, múltiples entidades o actividad activa. |
| High | Alta | Actividad sospechosa fuerte, técnica conocida o entidad crítica. |
| Medium | Media | Requiere contexto adicional. |
| Low | Baja | Señal débil o informativa, posible ruido. |
| Informational | Seguimiento | Útil para contexto o tendencia. |

## Factores que suben prioridad

- Host crítico o servidor expuesto.
- Usuario privilegiado.
- IOC con reputación maliciosa.
- Actividad lateral o persistencia.
- Múltiples alertas relacionadas.
- Confirmación por varias fuentes.

## Factores que bajan prioridad

- Actividad esperada por administración.
- Herramienta corporativa conocida.
- Ruta, firma o hash validado.
- Cambio planificado.
- Detección repetitiva ya documentada como falso positivo.

> [!NOTE]
> Para usuario no técnico: severidad no significa culpabilidad. Significa urgencia estimada para revisar.

Relacionado: [[falso-positivo-vs-true-positive]], [[checklist-analisis-alerta]].

