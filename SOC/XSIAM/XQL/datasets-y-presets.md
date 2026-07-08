# Datasets y presets

## Dataset

Un dataset es una colección de datos consultable. Puede representar telemetría de endpoint, alertas, eventos cloud, inventario u otra fuente.

## Preset

Un preset es una vista o conjunto preparado de campos/datos para facilitar consultas habituales.

> [!NOTE]
> Dataset es "dónde están los datos". Preset es "una forma preparada de mirarlos".

## Buenas prácticas

- Identifica primero el dataset correcto.
- Comprueba campos con una query pequeña.
- Usa filtros temporales y de entidad.
- No asumas que un dataset existe en todos los tenants.
- Documenta el dataset usado en cada investigación.

## Ejemplo orientativo

```xql
dataset = xdr_data
| filter agent_hostname = "HOST-001"
| fields _time, agent_hostname, actor_effective_username, action_process_image_name
| limit 50
```

> [!WARNING]
> La disponibilidad de datasets puede depender de licencia, producto activado, retención, ingesta y permisos.

Relacionado: [[introduccion-xql]], [[campos-comunes]], [[joins-en-xql]].

