# Zeek

## Idea clave

**Zeek** es una plataforma de monitorización de red que genera logs estructurados sobre conexiones, DNS, HTTP, SSL/TLS, ficheros y otros protocolos.

Para un analista SOC, Zeek ayuda a responder:

- qué host habló con qué destino;
- qué dominio se resolvió;
- qué URL o user-agent aparece;
- cuánto tráfico hubo;
- qué actividad de red coincide con una alerta endpoint.

## Logs frecuentes

| Log | Uso SOC |
|---|---|
| `conn` | Conexiones, IPs, puertos, duración, bytes |
| `dns` | Consultas y respuestas DNS |
| `http` | Hosts, URLs, métodos, user-agent |
| `ssl` / `x509` | SNI, certificados y metadatos TLS |
| `files` | Ficheros observados en tráfico |

> [!TIP]
> Zeek cuenta la historia de red. Combínalo con [[Windows]] o [[conceptos-basicos-sysmon]] para conectar una conexión con un proceso.

Relacionado: [[Redes]], [[modelo-osi]], [[SIEM]], [[Elastic]], [[CDSA]], [[02-checklist-hunting-elastic-windows-zeek]].

