# Splunk

Carpeta de estudio sobre Splunk como SIEM y SPL para análisis SOC.

## Objetivo

Entender qué es Splunk, cómo se organiza su arquitectura básica y cómo usar SPL para buscar, filtrar, transformar y enriquecer eventos.

## Entradas

| Nota | Para qué sirve |
|---|---|
| [[00-introduccion-splunk-y-spl]] | Base práctica de Splunk, arquitectura, SPL y comparación con Elastic/XSIAM |
| [[01-identificar-datos-y-campos-en-splunk]] | Descubrir índices, sourcetypes, sources, campos y modelos de datos |

## Uso recomendado

1. Entender arquitectura: forwarder, indexer, search head.
2. Identificar datos disponibles con [[01-identificar-datos-y-campos-en-splunk]].
3. Aprender búsquedas SPL básicas.
4. Practicar filtros por índice, `sourcetype`, `host`, `EventCode` y tiempo.
5. Usar `table`, `stats`, `eval`, `rex`, `lookup` y `transaction`.
6. Comparar SPL con [[Elastic]]/KQL y [[Cortex-XSIAM]]/XQL.

Relacionado: [[SIEM]], [[Elastic]], [[Cortex-XSIAM]], [[Kibana]], [[CDSA]].
