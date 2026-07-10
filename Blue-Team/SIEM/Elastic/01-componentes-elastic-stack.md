# Componentes de Elastic Stack

## Idea clave

Elastic Stack se compone de piezas que cubren el ciclo de vida del dato: recolección, procesamiento, almacenamiento, búsqueda y visualización.

En un contexto SIEM, cada componente cumple una función dentro del flujo de investigación SOC.

```text
Fuentes de seguridad -> Beats -> Logstash -> Elasticsearch -> Kibana -> Analista SOC
```

> [!NOTE]
> Para un analista SOC junior/intermedio, lo importante es entender qué componente toca el dato en cada fase y dónde buscar cuando algo falla.

## Componentes principales

| Componente | Función | Uso SOC |
|---|---|---|
| Beats | Agente ligero para recopilar logs/métricas | Enviar eventos de endpoints, servidores y red |
| Logstash | Pipeline de procesamiento | Normalización, enriquecimiento y transformación |
| Elasticsearch | Motor de búsqueda e indexación | Consultar eventos, buscar IOC, correlacionar |
| Kibana | Interfaz visual | Dashboards, búsquedas, análisis e investigación |

## Beats relevantes

| Beat | Uso típico | Ejemplo SOC |
|---|---|---|
| Filebeat | Recolección de logs de archivos | Logs de aplicaciones, firewalls o servicios |
| Winlogbeat | Eventos de Windows | Logon fallidos, creación de procesos, cambios de servicio |
| Metricbeat | Métricas de sistemas y servicios | CPU, memoria, estado de servicios |
| Packetbeat | Datos de red | Metadatos de tráfico y protocolos |
| Auditbeat | Auditoría de Linux | Cambios de archivos, usuarios, procesos |
| Heartbeat | Monitorización de disponibilidad | Comprobar si servicios o endpoints responden |

> [!WARNING]
> La disponibilidad, mantenimiento o recomendación concreta de cada Beat puede cambiar por versión. TODO: validar con documentación oficial de Elastic antes de diseñar una arquitectura nueva.

## Logstash

Logstash recibe eventos, los procesa y los envía a un destino como Elasticsearch.

En SOC se usa para:

- Parsear logs.
- Normalizar campos.
- Enriquecer eventos.
- Filtrar ruido.
- Convertir formatos.
- Añadir contexto antes de indexar.

## Elasticsearch

Elasticsearch almacena e indexa los eventos para permitir búsquedas rápidas.

En SOC se usa para:

- Buscar IOC como IPs, dominios, hashes o usuarios.
- Consultar eventos por rango temporal.
- Correlacionar campos entre fuentes.
- Alimentar dashboards, alertas y reglas.

## Kibana

Kibana es la interfaz principal del analista SOC.

En Kibana se puede:

- Buscar eventos con KQL.
- Revisar dashboards.
- Analizar timelines.
- Crear visualizaciones.
- Explorar índices y campos.
- Revisar alertas si la funcionalidad está habilitada.

## Arquitectura robusta

En entornos grandes puede añadirse infraestructura adicional para mejorar resiliencia, escalabilidad y seguridad.

| Componente adicional | Para qué sirve |
|---|---|
| Kafka | Cola de mensajería para desacoplar ingesta y procesamiento |
| Redis | Buffer o cola intermedia en pipelines |
| RabbitMQ | Mensajería entre productores y consumidores |
| Nginx | Proxy, terminación TLS o capa de seguridad |

> [!NOTE]
> Estas piezas no son obligatorias en todas las instalaciones. Se usan cuando el volumen, la criticidad o los requisitos de arquitectura lo justifican.

## Roles de nodos

| Rol | Función |
|---|---|
| Master | Coordina el clúster y su estado |
| Ingest | Procesa documentos antes de indexarlos |
| Data Hot | Almacena datos recientes y consultados con frecuencia |
| Data Warm | Almacena datos menos recientes o de menor consulta |
| Alerting | Ejecuta capacidades de alerta si están habilitadas |
| Machine Learning | Ejecuta capacidades ML si están licenciadas y configuradas |

> [!WARNING]
> La asignación exacta de roles y capacidades depende de versión, licencia, tamaño del entorno y diseño del clúster. TODO: validar con documentación oficial o laboratorio.

## Uso en SOC

| Necesidad SOC | Componente más relacionado |
|---|---|
| Recibir eventos Windows | Winlogbeat / Elastic Agent |
| Transformar logs antes de indexar | Logstash / ingest pipelines |
| Buscar actividad sospechosa | Elasticsearch |
| Investigar visualmente | Kibana |
| Absorber picos de ingesta | Kafka, Redis o RabbitMQ |
| Proteger acceso web | Nginx u otro proxy |

## Notas para CDSA

- Diferencia entre recolectar, procesar, indexar y visualizar.
- Antes de crear reglas, valida que el pipeline entrega eventos útiles.
- Un problema de detección puede estar en la fuente, el agente, el pipeline, el índice o la query.
- Para troubleshooting, piensa siempre en el flujo completo del dato.

## Checklist rápido

- [ ] ¿Qué fuente genera el log?
- [ ] ¿Qué agente lo recoge?
- [ ] ¿Pasa por Logstash o ingest pipeline?
- [ ] ¿En qué índice queda guardado?
- [ ] ¿Qué campos están disponibles?
- [ ] ¿Kibana permite buscarlo?
- [ ] ¿El analista entiende el evento?

Relacionado: [[00-elastic-stack-como-siem]], [[02-kql-para-soc]].

