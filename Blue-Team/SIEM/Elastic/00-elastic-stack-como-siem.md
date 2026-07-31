# Elastic Stack como SIEM

## Idea clave

Elastic Stack puede funcionar como solución SIEM porque permite recopilar, almacenar, buscar, analizar, correlacionar y visualizar datos de seguridad desde múltiples fuentes.

En un SOC, esto permite investigar eventos de firewalls, IDS/IPS, endpoints, servidores, aplicaciones y dispositivos de red desde una plataforma centralizada.

```text
Fuentes de seguridad -> Beats/Logstash -> Elasticsearch -> Kibana -> Investigación SOC
```

> [!NOTE]
> Para un analista SOC: Elastic como SIEM no es solo "guardar logs". Es tener una forma rápida de preguntar qué pasó, cuándo pasó, dónde pasó y qué entidades están afectadas.

## Qué problema resuelve

Un SOC necesita convertir grandes volúmenes de logs en evidencia útil. Elastic Stack ayuda a centralizar esos datos y hacerlos consultables para tareas como:

- Investigación de alertas.
- Búsqueda de IOC.
- Revisión de actividad de usuarios y hosts.
- Análisis temporal de eventos.
- Creación de dashboards.
- Desarrollo de detecciones y casos de uso.

## Flujo básico

| Paso | Componente | Qué ocurre |
|---|---|---|
| 1 | Fuentes de seguridad | Generan logs y eventos desde endpoints, red, servidores, aplicaciones o cloud. |
| 2 | Beats / Logstash | Recopilan, procesan, transforman o normalizan eventos. |
| 3 | Elasticsearch | Almacena, indexa y permite búsquedas sobre los datos. |
| 4 | Kibana | Permite consultar, visualizar, investigar y crear dashboards. |
| 5 | Analista SOC | Analiza evidencias, valida hipótesis y documenta conclusiones. |

## Componentes en una frase

| Componente | Explicación sencilla | Uso SOC |
|---|---|---|
| Beats | Agentes ligeros para recopilar datos. | Enviar eventos desde endpoints, servidores o servicios. |
| Logstash | Pipeline de ingesta y procesamiento. | Normalizar, transformar y enriquecer logs. |
| Elasticsearch | Motor de búsqueda e indexación. | Buscar eventos, correlacionar datos y consultar IOC. |
| Kibana | Interfaz visual de Elastic. | Investigar, filtrar, visualizar y construir dashboards. |

## Uso en SOC

Elastic como SIEM se usa para convertir preguntas operativas en búsquedas sobre datos:

| Pregunta SOC | Ejemplo de análisis |
|---|---|
| ¿Qué usuario falló autenticación repetidamente? | Buscar eventos Windows `4625`. |
| ¿Qué host contactó una IP sospechosa? | Filtrar por `destination.ip`. |
| ¿Qué proceso ejecutó una alerta? | Revisar campos de proceso y proceso padre. |
| ¿Hay actividad similar en más equipos? | Buscar por hash, nombre de proceso o patrón de comando. |

## Ejemplo conceptual

Si un firewall registra una conexión a una IP sospechosa, Elastic puede ayudar a:

1. Recibir el log desde la fuente.
2. Indexarlo en Elasticsearch.
3. Buscar la IP en Kibana.
4. Ver qué host o usuario estuvo relacionado.
5. Correlacionar con eventos de endpoint.
6. Documentar si hay riesgo real o falso positivo.

## Notas para CDSA

- Entender el flujo de datos es más importante que memorizar pantallas.
- Antes de crear una detección, valida que los logs existen y contienen campos útiles.
- KQL ayuda a investigar rápido, pero la calidad de la detección depende de los datos disponibles.
- Un SIEM no reemplaza el criterio del analista: centraliza evidencias para tomar mejores decisiones.

## Límites y validaciones

> [!WARNING]
> La arquitectura exacta depende del entorno, licenciamiento, versión de Elastic, fuentes integradas y configuración de índices, pipelines y permisos.

> [!WARNING]
> Antes de usar una query o detección en producción, validar campos, índices y normalización en laboratorio o documentación oficial.

## TODO

- TODO: validar con documentación oficial de Elastic los nombres actuales de componentes y capacidades por licencia.
- TODO: añadir diagrama Mermaid cuando se documente la arquitectura completa.

Relacionado: [[Elastic]], [[SIEM]], [[01-componentes-elastic-stack]], [[02-kql-para-soc]].
