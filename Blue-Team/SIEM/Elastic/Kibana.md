# Kibana

## Idea clave

**Kibana** es la interfaz de Elastic para explorar datos, crear visualizaciones, consultar eventos y trabajar con dashboards.

En un contexto SOC/CDSA, Kibana se usa sobre todo para:

- buscar eventos;
- filtrar por tiempo;
- pivotar por campos;
- revisar timelines;
- comparar actividad endpoint y red;
- apoyar investigaciones en [[Elastic]].

> [!NOTE]
> Los nombres de índices, data views y campos pueden variar según el laboratorio o integración.

## Uso rápido en SOC

| Acción | Para qué sirve |
|---|---|
| Ajustar rango temporal | Evitar ruido y centrar la investigación |
| Filtrar por campo | Buscar host, usuario, proceso, IP o dominio |
| Ordenar por tiempo | Reconstruir secuencia de eventos |
| Explorar campos | Entender qué telemetría está disponible |
| Guardar pivotes | Documentar evidencias |

Relacionado: [[Elastic]], [[SIEM]], [[02-kql-para-soc]], [[CDSA]], [[02-checklist-hunting-elastic-windows-zeek]].

