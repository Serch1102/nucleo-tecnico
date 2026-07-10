# Estructura básica de una query XQL

Una query suele tener esta forma:

```xql
dataset = <nombre_dataset>
| filter <condicion>
| fields <campo1>, <campo2>, <campo3>
| sort desc <campo_tiempo>
| limit 100
```

## Partes

| Parte | Función |
|---|---|
| `dataset` | Define dónde buscar. |
| `filter` | Reduce resultados. |
| `fields` | Muestra solo campos útiles. |
| `sort` | Ordena resultados. |
| `limit` | Evita traer demasiado volumen. |
| `comp` | Agrega o cuenta resultados, si aplica. |
| `join` | Une datos de otra búsqueda, si aplica. |

> [!TIP]
> Empieza con filtros concretos y `limit`. Luego amplía.

## Ejemplo por usuario

```xql
dataset = xdr_data
| filter actor_effective_username contains "usuario"
| fields _time, agent_hostname, actor_effective_username, actor_process_image_name, action_process_image_command_line
| sort desc _time
| limit 100
```

Relacionado: [[filtros-y-operadores]], [[campos-comunes]], [[errores-comunes-xql]].

