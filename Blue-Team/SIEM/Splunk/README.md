# Splunk

Carpeta de estudio sobre Splunk como SIEM y SPL para análisis SOC.

## Objetivo

Entender qué es Splunk, cómo se organiza su arquitectura básica y cómo usar SPL para buscar, filtrar, transformar y enriquecer eventos.

## Entradas

| Nota | Para qué sirve |
|---|---|
| [[00-introduccion-splunk-y-spl]] | Base práctica de Splunk, arquitectura, SPL y comparación con Elastic/XSIAM |

## Uso recomendado

1. Entender arquitectura: forwarder, indexer, search head.
2. Aprender búsquedas SPL básicas.
3. Practicar filtros por índice, `sourcetype`, `host`, `EventCode` y tiempo.
4. Usar `table`, `stats`, `eval`, `rex`, `lookup` y `transaction`.
5. Comparar SPL con [[Elastic]]/KQL y [[Cortex-XSIAM]]/XQL.

Relacionado: [[SIEM]], [[Elastic]], [[Cortex-XSIAM]], [[Kibana]], [[CDSA]].

