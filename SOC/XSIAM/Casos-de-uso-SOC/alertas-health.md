# Caso de uso SOC: Alertas health

## Qué significa

Alertas relacionadas con estado de agentes, conectividad, ingesta, sensores o componentes de seguridad.

## Qué revisar

- Qué componente reporta problema.
- Desde cuándo ocurre.
- Alcance: un host, varios hosts o tenant completo.
- Impacto en visibilidad.
- Cambios recientes.

## Query útil orientativa

```xql
// Orientativo: validar dataset de health/management disponible en el tenant.
dataset = xdr_data
| filter agent_hostname = "HOST-001"
| fields _time, agent_hostname, agent_status, agent_version
| sort desc _time
| limit 50
```

## Señales de riesgo

- Pérdida de telemetría en activos críticos.
- Muchos agentes desconectados.
- Fallo después de cambio o actualización.

## Señales de falso positivo

- Equipo apagado o retirado.
- Mantenimiento programado.
- Problema temporal ya recuperado.

## Decisión recomendada

Priorizar si afecta visibilidad de activos críticos o múltiples endpoints.

## Ejemplo de cierre

Se confirma que el host estaba apagado por mantenimiento planificado. No hay pérdida operativa no esperada. Se cierra como informativo.

