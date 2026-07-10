# Anatomía de una alerta

Una alerta es una señal que indica una posible actividad sospechosa o relevante para seguridad.

## Partes habituales

| Campo | Para qué sirve |
|---|---|
| Nombre de alerta | Resume la detección. |
| Severidad | Ayuda a priorizar. |
| Timestamp | Indica cuándo ocurrió o cuándo se detectó. |
| Host | Equipo afectado o relacionado. |
| Usuario | Cuenta implicada. |
| IP origen/destino | Contexto de red. |
| Proceso | Ejecutable o comando relacionado. |
| Evidencias | Eventos o datos que justifican la alerta. |
| MITRE ATT&CK | Técnica o táctica asociada, si existe. |

> [!WARNING]
> No asumas que todos los campos existen siempre. El nombre del dataset/campo puede variar según la ingesta y configuración del tenant.

## Para un analista SOC

No empieces por cerrar la alerta. Empieza por entender:

1. Qué detectó la plataforma.
2. Qué entidad está afectada.
3. Si hay comportamiento previo o posterior.
4. Si la actividad tiene explicación legítima.
5. Qué impacto potencial existe.

Relacionado: [[campos-importantes]], [[severidades-y-priorizacion]], [[checklist-analisis-alerta]].

