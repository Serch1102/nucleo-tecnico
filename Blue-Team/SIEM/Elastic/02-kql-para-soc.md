# KQL para SOC

## Idea clave

KQL, Kibana Query Language, es el lenguaje de consulta usado en Kibana para filtrar eventos de forma rápida.

La estructura básica es:

```kql
campo:valor
```

Ejemplo:

```kql
event.code:4625
```

`event.code:4625` representa intentos fallidos de inicio de sesión en Windows.

> [!NOTE]
> KQL ayuda a investigar, acotar ruido y validar hipótesis. No sustituye entender qué significan los eventos.

## Búsqueda de texto libre

Busca el texto en los campos indexados disponibles.

```kql
"svc-sql1"
```

Uso SOC:

- Buscar un hostname.
- Buscar un usuario.
- Buscar una cadena observada en una alerta.

## Búsqueda por campo

```kql
event.code:4625
```

Uso SOC:

- Buscar un tipo concreto de evento.
- Reducir resultados a una fuente o código concreto.
- Trabajar con campos normalizados.

## Operador AND

```kql
event.code:4625 AND winlog.event_data.SubStatus:0xC0000072
```

Esta query busca eventos de logon fallido donde el subestado indica cuenta deshabilitada.

## Comparación temporal

```kql
event.code:4625 AND winlog.event_data.SubStatus:0xC0000072 AND @timestamp >= "2023-03-03T00:00:00.000Z" AND @timestamp <= "2023-03-06T23:59:59.999Z"
```

Uso SOC:

- Acotar una investigación a una ventana concreta.
- Revisar actividad antes/después de una alerta.
- Reducir volumen.

> [!TIP]
> En Kibana normalmente también puedes ajustar el rango temporal desde la interfaz. La condición sobre `@timestamp` es útil cuando quieres dejar la query autocontenida o documentada.

## Wildcard

```kql
event.code:4625 AND user.name:admin*
```

Uso SOC:

- Buscar variaciones de cuentas.
- Encontrar usuarios con prefijo común.
- Investigar patrones de naming.

> [!WARNING]
> Los wildcards amplios pueden generar mucho volumen. Úsalos con rango temporal y campos concretos.

## Query: cuenta deshabilitada

```kql
event.code:4625 AND winlog.event_data.SubStatus:0xC0000072
```

### Qué significa cada parte

| Parte | Significado |
|---|---|
| `event.code:4625` | Failed logon en Windows |
| `winlog.event_data.SubStatus:0xC0000072` | Account currently disabled |
| `@timestamp` | Campo temporal para acotar la búsqueda |
| `winlog.event_data.TargetUserName` | Suele contener el usuario afectado |

> [!WARNING]
> Los nombres exactos de campos pueden variar según integración, versión, ECS, pipeline o normalización. TODO: validar en laboratorio o documentación oficial.

## Justificación SOC

Esta query ayuda a detectar intentos de autenticación contra cuentas deshabilitadas.

Puede indicar:

- Credenciales antiguas.
- Password spraying.
- Servicios mal configurados.
- Tareas programadas antiguas.
- Actividad maliciosa usando cuentas fuera de uso.

## Flujo de análisis recomendado

1. Buscar eventos `4625` con substatus de cuenta deshabilitada.
2. Identificar usuario afectado.
3. Revisar origen de autenticación.
4. Revisar host objetivo.
5. Contar frecuencia y distribución temporal.
6. Comparar con otros eventos del mismo usuario.
7. Decidir si es configuración antigua, ruido o actividad sospechosa.

## Campos útiles

| Campo | Pregunta SOC |
|---|---|
| `@timestamp` | ¿Cuándo ocurrió? |
| `event.code` | ¿Qué tipo de evento es? |
| `user.name` | ¿Qué usuario aparece normalizado? |
| `winlog.event_data.TargetUserName` | ¿Qué usuario fue objetivo del logon? |
| `source.ip` | ¿Desde dónde vino el intento? |
| `host.name` | ¿Qué sistema generó el evento? |
| `winlog.event_data.SubStatus` | ¿Cuál fue la razón técnica del fallo? |

## Notas para CDSA

- Aprende primero `campo:valor`, `AND`, rangos temporales y wildcards.
- Documenta siempre qué significa cada campo, no solo la query.
- Una query útil debe responder una pregunta SOC concreta.
- Si una query genera mucho ruido, añade contexto: usuario, host, origen, ventana temporal o frecuencia.

## Uso en SOC

| Situación | Query base |
|---|---|
| Logons fallidos Windows | `event.code:4625` |
| Cuenta deshabilitada | `event.code:4625 AND winlog.event_data.SubStatus:0xC0000072` |
| Usuarios admin | `user.name:admin*` |
| Texto libre | `"svc-sql1"` |

Relacionado: [[01-componentes-elastic-stack]], [[03-use-case-development-siem]].

