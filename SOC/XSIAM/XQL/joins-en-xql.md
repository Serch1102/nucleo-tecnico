---
title: Joins en XQL para Cortex XSIAM
created: 2026-07-08
tags:
  - SOC
  - XSIAM
  - XQL
  - Detection Engineering
  - Correlation Rules
status: entrada de estudio
nivel: L1 -> L3
---

# Joins en XQL para Cortex XSIAM

## Objetivo

Esta entrada resume cómo usar `join` en XQL para juntar información de varios datasets en Cortex XSIAM/XDR.

La idea no es memorizar sintaxis, sino entender el patrón profesional:

```text
dataset principal filtrado
-> normalizar clave
-> seleccionar campos mínimos
-> subquery filtrada
-> normalizar clave derecha
-> deduplicar/agregar
-> join
-> fields finales
-> sort
-> limit
```

En un proyecto L3, `join` se usa sobre todo para enriquecer detecciones: añadir contexto de inventario, usuarios críticos, threat intel, assets cloud, findings, endpoints, logs de autenticación o actividad SaaS.

---

## 1. Qué hace `join`

`join` combina los resultados de dos queries en una sola tabla usando una condición común.

Ejemplo mental:

```text
Dataset A: eventos de red
Dataset B: inventario de endpoints

Clave común: hostname

Resultado:
evento de red + estado del endpoint + grupo + sistema operativo + usuario
```

En seguridad sirve para enriquecer datos.

| Tengo | Lo junto con | Para conseguir |
|---|---|---|
| Eventos XDR | Inventario endpoint | Estado, grupo, tipo de endpoint |
| Logins | Inventario de usuarios | Departamento, rol, criticidad |
| Alertas | Eventos XDR | Proceso, hash, usuario, host |
| CloudTrail | Asset inventory | Recurso, criticidad, owner |
| File events | Threat Intel | Si hash/IP/dominio está listado |
| DLP/AI logs | Endpoint/user inventory | Usuario, host, contexto del upload |

Frase clave:

> `join` no es para buscar más datos a lo loco. Es para añadir contexto útil a datos que ya has reducido.

---

## 2. Sintaxis base

La forma general es:

```xql
join conflict_strategy = both|left|right
     type = inner|left|right
     (
       <xql query>
     ) as <alias>
     <condición_booleana>
```

Ejemplo mínimo:

```xql
config timeframe = 1 d
| dataset = dataset_a
| fields user_id, hostname, event_name
| join type = inner (
    dataset = dataset_b
    | fields user_id as joined_user_id, department
) as b b.joined_user_id = user_id
| fields user_id, hostname, event_name, department
| limit 100
```

Traducción:

```text
1. Coge eventos de dataset_a.
2. Coge usuarios/departamento de dataset_b.
3. Une ambos cuando b.joined_user_id sea igual a user_id.
4. Muestra evento + departamento.
```

---

## 3. Tipos de join

## 3.1 Inner join

Devuelve solo los registros que tienen coincidencia en ambos lados.

```xql
config timeframe = 1 d
| dataset = sample_xql_raw
| filter event_id in (101, 102, 103, 104)
| fields event_id, event_description
| join type = inner (
    dataset = sample_xql_raw
    | filter event_id in (103, 104, 105, 106)
    | fields event_id as joined_event_id, is_successful as success_status
) as right_data right_data.joined_event_id = event_id
```

Resultado conceptual:

```text
Solo salen 103 y 104, porque existen en ambos lados.
```

Usarlo cuando quieres:

> Dame solo eventos que tengan match en la otra fuente.

Casos típicos:

| Caso | Condición |
|---|---|
| Eventos de red contra IPs de threat intel | `network.dst_ip = ti.ip` |
| Host con alerta y proceso sospechoso | `alerts.host = xdr.host` |
| Usuario con login raro y usuario VIP | `auth.user = vip.user` |

---

## 3.2 Left join

Devuelve todo lo del lado izquierdo y añade datos del lado derecho solo si hay match.

Si no hay match, los campos derechos salen como `null`.

```xql
config timeframe = 1 d
| dataset = sample_xql_raw
| filter event_id in (101, 102, 103, 104)
| fields event_id, event_description
| join type = left (
    dataset = sample_xql_raw
    | filter event_id in (103, 104, 105, 106)
    | fields event_id as joined_event_id, is_successful as success_status
) as right_data right_data.joined_event_id = event_id
```

Resultado conceptual:

```text
101 -> sin match, campos derechos null
102 -> sin match, campos derechos null
103 -> con match
104 -> con match
```

Es el tipo más útil para investigaciones porque no pierdes eventos principales.

Usarlo cuando quieres:

> Mantener todos mis eventos principales, aunque no tengan información extra.

Casos típicos:

| Caso | Ejemplo |
|---|---|
| Mantener todos los uploads a IA y añadir endpoint si existe | Uploads + endpoints |
| Mantener todas las alertas y añadir CMDB si existe | Alerts + CMDB |
| Mantener todos los logins fallidos y añadir datos de usuario | Auth + user inventory |

---

## 3.3 Right join

Devuelve todo lo del lado derecho y añade datos del lado izquierdo si hay coincidencia.

```xql
config timeframe = 1 d
| dataset = sample_xql_raw
| filter event_id in (101, 102, 103, 104)
| fields event_id, event_description
| join type = right (
    dataset = sample_xql_raw
    | filter event_id in (103, 104, 105, 106)
    | fields event_id as joined_event_id, is_successful as success_status
) as right_data right_data.joined_event_id = event_id
```

En SOC se usa menos. Normalmente es más legible cambiar el orden y usar `left join`.

En vez de:

```xql
dataset = eventos
| join type = right (
    dataset = inventario
) as inv inv.host = hostname
```

Mejor:

```xql
dataset = inventario
| join type = left (
    dataset = eventos
) as ev ev.hostname = host
```

---

## 4. `conflict_strategy`

Cuando ambos lados tienen campos con el mismo nombre, por ejemplo `hostname`, `user`, `_product`, `event_id`, XQL necesita decidir cuál conservar.

Opciones:

| Estrategia | Qué hace | Cuándo usarla |
|---|---|---|
| `left` | Conserva el campo del dataset principal | Cuando el lado izquierdo es la fuente de verdad |
| `right` | Conserva el campo de la subquery | Cuando el enriquecimiento manda |
| `both` | Conserva ambos campos, renombrando duplicados | Cuando estás depurando |

Recomendación práctica:

```text
Mientras pruebas -> conflict_strategy = both
Cuando ya está claro -> conflict_strategy = left o right
```

Ejemplo:

```xql
config timeframe = 1 d
| dataset = xdr_data
| fields agent_id, event_id, _product as product
| join conflict_strategy = both (
    dataset = panw_ngfw_filedata_raw
    | fields _product as product
) as panw _time = panw._time
| limit 100
```

---

## 5. Patrón profesional para hacer joins sin romper nada

No empezar directamente con un join gigante.

### Paso 1: probar el lado izquierdo solo

```xql
config timeframe = 1 d
| dataset = xdr_data
| filter agent_hostname != null and agent_hostname != ""
| fields _time, agent_hostname, actor_effective_username, event_type, event_sub_type
| limit 100
```

### Paso 2: probar el lado derecho solo

```xql
config timeframe = 1 d
| dataset = endpoints
| filter endpoint_name != null and endpoint_name != ""
| fields endpoint_name, endpoint_status, endpoint_type, group_names
| limit 100
```

### Paso 3: normalizar claves

Los joins fallan mucho por diferencias de formato:

```text
PC-001
pc-001
pc-001.empresa.local
```

Normalización simple:

```xql
| alter join_host = lowercase(agent_hostname)
```

Si el hostname viene como FQDN:

```xql
| alter join_host = lowercase(arrayindex(split(agent_hostname, "."), 0))
```

### Paso 4: reducir el lado derecho

Si el lado derecho tiene muchos registros por clave, el join puede multiplicar filas.

Ejemplo:

```text
1 evento izquierdo para host01
30 eventos derechos para host01
Resultado = 30 filas
```

Reducir:

```xql
config timeframe = 1 d
| dataset = endpoints
| filter endpoint_name != null and endpoint_name != ""
| alter ep_join_host = lowercase(endpoint_name)
| dedup ep_join_host
| fields ep_join_host, endpoint_status, endpoint_type, group_names
```

### Paso 5: unir

```xql
config timeframe = 1 d
| dataset = xdr_data
| filter agent_hostname != null and agent_hostname != ""
| alter join_host = lowercase(agent_hostname)
| fields _time, join_host, agent_hostname, actor_effective_username, event_type, event_sub_type
| join type = left conflict_strategy = left (
    dataset = endpoints
    | filter endpoint_name != null and endpoint_name != ""
    | alter ep_join_host = lowercase(endpoint_name)
    | dedup ep_join_host
    | fields ep_join_host, endpoint_status, endpoint_type, group_names
) as ep ep.ep_join_host = join_host
| fields _time, agent_hostname, actor_effective_username, event_type, event_sub_type, endpoint_status, endpoint_type, group_names
| sort desc _time
| limit 100
```

Nota importante:

> `join` no conserva el orden. Si necesitas ordenar, usa `sort` después del `join`.

---

## 6. Reglas de oro

## 6.1 Filtra antes del join

Malo:

```xql
dataset = xdr_data
| join (
    dataset = endpoints
) as ep ep.endpoint_name = agent_hostname
| filter event_type = PROCESS
```

Mejor:

```xql
dataset = xdr_data
| filter event_type = PROCESS
| filter agent_hostname != null and agent_hostname != ""
| fields _time, agent_hostname, actor_effective_username, event_type, event_sub_type
| join (
    dataset = endpoints
    | fields endpoint_name, endpoint_status
) as ep ep.endpoint_name = agent_hostname
```

## 6.2 Selecciona campos mínimos

Bueno:

```xql
| fields _time, agent_hostname, actor_effective_username, action_process_image_name
```

Malo:

```xql
| fields *
```

## 6.3 Filtra `null` y string vacío

```xql
| filter user_name != null and user_name != ""
```

En XQL, `null` y `""` no son lo mismo.

## 6.4 Usa `in` si solo necesitas comprobar pertenencia

Si solo quieres saber si una IP está en una lista, quizá no necesitas join.

```xql
config timeframe = 1 d
| dataset = xdr_data
| filter action_remote_ip != null and action_remote_ip != ""
| filter action_remote_ip in (
    dataset = malicious_ips_lookup
    | fields indicator_ip
)
| fields _time, agent_hostname, actor_effective_username, action_remote_ip, action_remote_port
| sort desc _time
| limit 100
```

Usa `join` si necesitas traer columnas extra como `confidence`, `source`, `threat_type`, etc.

---

## 7. Práctica: enriquecer eventos XDR con inventario endpoint

Objetivo:

```text
Ver eventos XDR y añadir estado/grupo del endpoint.
```

Query:

```xql
config timeframe = 1 d
| dataset = xdr_data
| filter agent_hostname != null and agent_hostname != ""
| alter join_host = lowercase(agent_hostname)
| fields _time, join_host, agent_hostname, actor_effective_username, event_type, event_sub_type
| join type = left conflict_strategy = left (
    dataset = endpoints
    | filter endpoint_name != null and endpoint_name != ""
    | alter ep_join_host = lowercase(endpoint_name)
    | dedup ep_join_host
    | fields ep_join_host, endpoint_status, endpoint_type, group_names
) as ep ep.ep_join_host = join_host
| fields _time, agent_hostname, actor_effective_username, event_type, event_sub_type, endpoint_status, endpoint_type, group_names
| sort desc _time
| limit 100
```

Qué hace:

```text
1. Coge eventos de xdr_data.
2. Normaliza hostname.
3. Coge inventario endpoint.
4. Normaliza endpoint_name.
5. Deduplica para no multiplicar filas.
6. Añade estado, tipo y grupo al evento.
```

Si falla, puede que estos campos se llamen distinto:

```text
endpoint_name
endpoint_status
endpoint_type
group_names
```

Descubrir campos:

```xql
config timeframe = 1 d
| dataset = endpoints
| fields *name*, *status*, *group*, *type*
| limit 50
```

---

## 8. Práctica: eventos Windows raw + eventos EDR

Objetivo:

```text
Ver evento Windows raw y añadir contexto EDR asociado.
```

Query base:

```xql
config timeframe = 1 d
| dataset = microsoft_windows_raw
| filter edr_event_id != null
| filter edr_event_id in (4624, 4625, 4688, 7045)
| fields _time, edr_event_id, host_name, user_name
| join type = left (
    dataset = xdr_data
    | filter event_type = EVENT_LOG
    | filter event_id in (4624, 4625, 4688, 7045)
    | fields event_id as joined_event_id, actor_process_image_name, actor_effective_username, agent_hostname
) as edr edr.joined_event_id = edr_event_id
| fields _time, host_name, user_name, edr_event_id, actor_process_image_name, actor_effective_username, agent_hostname
| sort desc _time
| limit 100
```

Casos útiles:

| Event ID | Uso habitual |
|---|---|
| 4624 | Logon correcto |
| 4625 | Logon fallido |
| 4688 | Creación de proceso |
| 7045 | Servicio instalado |

Posibles problemas:

| Problema | Causa probable |
|---|---|
| No devuelve nada | `edr_event_id` no existe o no coincide |
| Demasiadas filas | Muchos eventos con el mismo event_id |
| Campos vacíos | No todos los logs tienen proceso asociado |
| Timeout | Falta filtro por host, event_id o timeframe |

---

## 9. Práctica: eventos contra activos críticos

Supuesto: existe un lookup/custom dataset llamado `critical_assets_lookup`.

Campos supuestos:

```text
hostname
asset_owner
criticality
business_service
```

Query:

```xql
config timeframe = 1 d
| dataset = xdr_data
| filter agent_hostname != null and agent_hostname != ""
| alter join_host = lowercase(agent_hostname)
| fields _time, join_host, agent_hostname, actor_effective_username, event_type, event_sub_type, action_process_image_name
| join type = inner conflict_strategy = left (
    dataset = critical_assets_lookup
    | filter hostname != null and hostname != ""
    | alter critical_join_host = lowercase(hostname)
    | dedup critical_join_host
    | fields critical_join_host, asset_owner, criticality, business_service
) as ca ca.critical_join_host = join_host
| fields _time, agent_hostname, actor_effective_username, event_type, event_sub_type, action_process_image_name, criticality, asset_owner, business_service
| sort desc _time
| limit 200
```

Aquí usamos `inner` porque solo interesan eventos en activos críticos.

Para detection engineering:

```text
Evento sospechoso + activo crítico = subir severidad.
```

---

## 10. Práctica: eventos de red + threat intel

Supuesto:

```text
network events en xdr_data
threat intel en malicious_ips_lookup
```

Campos supuestos:

```text
xdr_data: action_remote_ip
malicious_ips_lookup: indicator_ip, threat_type, confidence
```

Versión con `join`:

```xql
config timeframe = 1 d
| dataset = xdr_data
| filter action_remote_ip != null and action_remote_ip != ""
| fields _time, agent_hostname, actor_effective_username, action_remote_ip, action_remote_port, event_type, event_sub_type
| join type = inner conflict_strategy = left (
    dataset = malicious_ips_lookup
    | filter indicator_ip != null and indicator_ip != ""
    | dedup indicator_ip
    | fields indicator_ip, threat_type, confidence
) as ti ti.indicator_ip = action_remote_ip
| fields _time, agent_hostname, actor_effective_username, action_remote_ip, action_remote_port, threat_type, confidence
| sort desc _time
| limit 100
```

Versión con `in` si solo queremos comprobar pertenencia:

```xql
config timeframe = 1 d
| dataset = xdr_data
| filter action_remote_ip != null and action_remote_ip != ""
| filter action_remote_ip in (
    dataset = malicious_ips_lookup
    | fields indicator_ip
)
| fields _time, agent_hostname, actor_effective_username, action_remote_ip, action_remote_port
| sort desc _time
| limit 100
```

Diferencia:

| Necesidad | Mejor opción |
|---|---|
| Solo saber si está en la lista | `in` |
| Traer `threat_type`, `confidence`, `source` | `join` |

---

## 11. Práctica: upload a IA + inventario endpoint

Objetivo:

```text
Buscar eventos relacionados con IA y enriquecerlos con inventario endpoint.
```

Query de descubrimiento:

```xql
config timeframe = 7 d
| dataset = xdr_data
| filter agent_hostname != null and agent_hostname != ""
| filter lowercase(to_string(_raw_log)) contains "chatgpt"
    or lowercase(to_string(_raw_log)) contains "openai"
    or lowercase(to_string(_raw_log)) contains "copilot"
    or lowercase(to_string(_raw_log)) contains "gemini"
    or lowercase(to_string(_raw_log)) contains "claude"
| alter join_host = lowercase(agent_hostname)
| fields _time, join_host, agent_hostname, actor_effective_username, dst_action_external_hostname, dst_action_url_category, _raw_log
| join type = left conflict_strategy = left (
    dataset = endpoints
    | filter endpoint_name != null and endpoint_name != ""
    | alter ep_join_host = lowercase(endpoint_name)
    | dedup ep_join_host
    | fields ep_join_host, endpoint_status, endpoint_type, group_names
) as ep ep.ep_join_host = join_host
| fields _time, agent_hostname, actor_effective_username, dst_action_external_hostname, dst_action_url_category, endpoint_status, endpoint_type, group_names, _raw_log
| sort desc _time
| limit 100
```

Aviso:

```text
_raw_log, dst_action_external_hostname o dst_action_url_category pueden no existir con esos nombres en el tenant.
```

Descubrir campos relacionados:

```xql
config timeframe = 7 d
| dataset = xdr_data
| fields *host*, *user*, *url*, *domain*, *file*, *raw*
| limit 50
```

Para nombres de ficheros:

```xql
config timeframe = 7 d
| dataset = xdr_data
| fields *file*, *filename*, *object*, *attachment*, *url*, *host*, *user*
| limit 100
```

---

## 12. Práctica: join con agregación previa

Caso:

```text
Detectar usuarios con muchos fallos de login y enriquecer con información de usuario VIP.
```

Primero agrupas:

```xql
config timeframe = 1 d
| dataset = auth_logs
| filter action_result = "FAILED"
| filter user_name != null and user_name != ""
| alter user_l = lowercase(user_name)
| comp count() as failed_count by user_l
| filter failed_count >= 10
```

Luego unes con VIP users:

```xql
config timeframe = 1 d
| dataset = auth_logs
| filter action_result = "FAILED"
| filter user_name != null and user_name != ""
| alter user_l = lowercase(user_name)
| comp count() as failed_count by user_l
| filter failed_count >= 10
| join type = left conflict_strategy = left (
    dataset = vip_users_lookup
    | filter user_name != null and user_name != ""
    | alter vip_user_l = lowercase(user_name)
    | dedup vip_user_l
    | fields vip_user_l, department, role, vip_level
) as vip vip.vip_user_l = user_l
| fields user_l, failed_count, department, role, vip_level
| sort desc failed_count
| limit 100
```

Esto es más eficiente que unir millones de eventos crudos.

---

## 13. Práctica: correlación temporal entre dos datasets

Caso:

```text
Usuario hace login sospechoso y después sube fichero a servicio IA.
```

Patrón correcto:

```text
1. Reducir login sospechoso.
2. Reducir eventos IA.
3. Normalizar usuario.
4. Join por usuario.
5. Filtrar relación temporal.
```

Ejemplo:

```xql
config timeframe = 1 d
| dataset = auth_logs
| filter action_result = "SUCCESS"
| filter user_name != null and user_name != ""
| filter source_country not in ("Spain", "ES")
| alter user_l = lowercase(user_name)
| fields _time as login_time, user_l, source_ip, source_country
| join type = inner conflict_strategy = left (
    dataset = xdr_data
    | filter actor_effective_username != null and actor_effective_username != ""
    | filter lowercase(to_string(_raw_log)) contains "chatgpt"
        or lowercase(to_string(_raw_log)) contains "openai"
        or lowercase(to_string(_raw_log)) contains "copilot"
    | alter user_l_ai = lowercase(actor_effective_username)
    | fields _time as ai_time, user_l_ai, agent_hostname, dst_action_external_hostname
) as ai ai.user_l_ai = user_l
| filter ai_time >= login_time
| fields login_time, ai_time, user_l, source_ip, source_country, agent_hostname, dst_action_external_hostname
| sort desc ai_time
| limit 100
```

Si la query va a convertirse en regla, seguramente será **Scheduled Correlation Rule**, no Real Time.

---

## 14. Joins dentro de Correlation Rules

Punto importante para proyectos L3:

```text
Si la query usa join, normalmente va como Scheduled Correlation Rule.
```

Las Real Time Correlation Rules son más limitadas y están pensadas para lógica simple.

Recomendación:

| Query | Tipo de regla recomendado |
|---|---|
| `dataset + filter + fields` simple | Real Time posible |
| Query con `join` | Scheduled |
| Query con agregaciones complejas | Scheduled |
| Query con varios datasets | Scheduled |
| Query con lógica temporal | Scheduled |

---

## 15. Errores típicos

## Error 1: claves con formato distinto

```text
agent_hostname = "PC-001"
endpoint_name = "pc-001.domain.local"
```

Solución:

```xql
| alter join_host = lowercase(arrayindex(split(agent_hostname, "."), 0))
```

## Error 2: no filtrar nulos

Malo:

```xql
| join (...) as b b.user = user
```

Bueno:

```xql
| filter user != null and user != ""
```

## Error 3: multiplicación de filas

```text
10 filas por usuario en lado izquierdo
20 filas por usuario en lado derecho
Resultado = 200 filas por usuario
```

Solución:

```xql
| dedup user
```

O agregar:

```xql
| comp latest(_time) as last_seen by user
```

## Error 4: conflictos de nombres

Solución durante pruebas:

```xql
| join conflict_strategy = both (...)
```

O renombrar campos:

```xql
| fields user_name as auth_user
```

## Error 5: ordenar antes del join

Malo:

```xql
| sort desc _time
| join (...)
```

Mejor:

```xql
| join (...)
| sort desc _time
```

## Error 6: usar join cuando bastaba `in`

Si solo necesitas comprobar existencia, usa `in`.

## Error 7: meter una query con join en Real Time Correlation Rule

Si lleva join, revisar primero si debe ser Scheduled.

---

## 16. Plantilla segura para joins

```xql
config timeframe = 1 d
| dataset = <dataset_principal>
| filter <clave_principal> != null and <clave_principal> != ""
| alter join_key = lowercase(<clave_principal>)
| fields _time, join_key, <campos_principales>
| join type = left conflict_strategy = left (
    dataset = <dataset_secundario>
    | filter <clave_secundaria> != null and <clave_secundaria> != ""
    | alter right_join_key = lowercase(<clave_secundaria>)
    | dedup right_join_key
    | fields right_join_key, <campos_de_enriquecimiento>
) as right_side right_side.right_join_key = join_key
| fields _time, <campos_principales>, <campos_de_enriquecimiento>
| sort desc _time
| limit 100
```

Versión para detección:

```xql
config timeframe = 1 d
| dataset = <dataset_principal>
| filter <condición_sospechosa>
| filter <clave_principal> != null and <clave_principal> != ""
| alter join_key = lowercase(<clave_principal>)
| comp count() as event_count by join_key, <entidad>
| filter event_count >= <umbral>
| join type = left conflict_strategy = left (
    dataset = <lookup_o_dataset_contexto>
    | filter <clave_contexto> != null and <clave_contexto> != ""
    | alter right_join_key = lowercase(<clave_contexto>)
    | dedup right_join_key
    | fields right_join_key, <contexto>
) as ctx ctx.right_join_key = join_key
| fields join_key, <entidad>, event_count, <contexto>
| sort desc event_count
| limit 100
```

---

## 17. Checklist antes de ejecutar un join pesado

```text
[ ] He probado el lado izquierdo solo.
[ ] He probado el lado derecho solo.
[ ] He confirmado que los campos existen.
[ ] He filtrado null y "" en las claves.
[ ] He normalizado mayúsculas/minúsculas con lowercase().
[ ] He reducido el timeframe.
[ ] He usado fields para seleccionar solo columnas necesarias.
[ ] He deduplicado o agregado el lado derecho si puede multiplicar filas.
[ ] He elegido type = inner/left/right con intención clara.
[ ] He elegido conflict_strategy.
[ ] He puesto sort después del join.
[ ] He usado limit mientras pruebo.
[ ] He valorado si IN era suficiente en vez de join.
[ ] Si va a correlation rule, he confirmado si debe ser Scheduled.
```

---

## 18. Decisión rápida

| Necesidad | Usa |
|---|---|
| Solo registros que existen en ambos datasets | `inner` |
| Mantener todos mis eventos principales y enriquecer si hay match | `left` |
| Mantener todo el dataset secundario | `right`, aunque suele ser mejor reordenar y usar `left` |
| No perder columnas duplicadas | `conflict_strategy = both` |
| Mantener campos del dataset principal | `conflict_strategy = left` |
| Mantener campos del enriquecimiento | `conflict_strategy = right` |
| Solo comprobar existencia en lista | `in` / `not in` |

---

## 19. Cómo explicarlo en una reunión L3

Frases útiles:

```text
Antes de hacer el join, reduciría ambos lados para evitar multiplicación de filas.
```

```text
Normalizaría la clave de correlación con lowercase() y filtraría null/empty antes de unir.
```

```text
Si solo necesitamos saber si el valor existe en una lista, usaría IN antes que JOIN.
```

```text
Para una detection rule con join, lo trataría como Scheduled Correlation Rule y validaría volumen histórico.
```

```text
Dejaría el join con conflict_strategy = both durante pruebas para detectar conflictos de campos.
```

---

## 20. Fuentes oficiales útiles

- XQL `join`: documentación oficial de Palo Alto Networks.
- Ejemplos oficiales de `inner`, `left`, `right` y `conflict_strategy`.
- XQL best practices: filtrar pronto, reducir campos y limitar resultados.
- Documentación de Correlation Rules en Cortex XSIAM.
- Documentación de datasets y presets en Cortex XSIAM/XDR.

---

## Resumen final

El patrón más importante para recordar:

```text
Filtrar -> normalizar -> reducir -> unir -> limpiar -> ordenar
```

Y la regla de oro:

> Una query con `join` no debe empezar siendo una detección. Primero debe ser una investigación controlada, medida y con volumen revisado.
