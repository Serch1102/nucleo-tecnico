# Errores comunes en XQL

| Error | Síntoma | Cómo resolver |
|---|---|---|
| Dataset incorrecto | No devuelve datos. | Validar dataset disponible y fuente de ingesta. |
| Campo inexistente | Error de campo o resultados vacíos. | Ejecutar query pequeña y revisar campos reales. |
| Filtro demasiado estricto | Cero resultados. | Quitar filtros uno a uno. |
| Volumen excesivo | Query lenta o truncada. | Añadir tiempo, entidad y `limit`. |
| Join sin clave estable | Duplicados o resultados incoherentes. | Usar clave más precisa como agent ID si existe. |
| Timestamps mezclados | Línea temporal confusa. | Diferenciar evento, ingesta y alerta. |
| Mayúsculas/minúsculas | No coincide texto esperado. | Probar `contains` o normalización si aplica. |

> [!TIP]
> La mejor forma de depurar una query es construirla por pasos y validar cada bloque.

Relacionado: [[estructura-basica-query]], [[joins-en-xql]], [[checklist-debug]].

