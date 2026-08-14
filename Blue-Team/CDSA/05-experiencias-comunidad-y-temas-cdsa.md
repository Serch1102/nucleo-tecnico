# Experiencias de comunidad y temas recurrentes CDSA

Investigado el 2026-08-14.

## Límite ético

Esta nota resume experiencias públicas de la comunidad sobre CDSA sin reproducir preguntas reales, flags, respuestas ni pasos específicos del examen.

> [!WARNING]
> No buscar ni guardar dumps de preguntas, flags, respuestas exactas o writeups que revelen contenido activo del examen. Eso puede violar reglas de HTB y además degrada el valor real de la certificación.

## Qué sí podemos usar

| Tipo de información | Uso seguro |
|---|---|
| Experiencias generales | Preparar metodología y expectativas |
| Herramientas mencionadas | Priorizar práctica técnica |
| Consejos de tiempo | Planificar la ventana de 7 días |
| Consejos de reporte | Mejorar documentación |
| Temas recurrentes | Guiar estudio sin copiar examen |

## Qué no debemos usar

| Tipo de información | Riesgo |
|---|---|
| Preguntas exactas | Posible contenido protegido del examen |
| Flags/respuestas | Trampa directa |
| Capturas de entorno de examen | Exposición de material privado |
| Writeups paso a paso del examen | Spoiler operativo |
| Nombres concretos de hosts/incidentes si proceden del examen | Puede revelar escenario |

## Patrón general que menciona la comunidad

La mayoría de experiencias públicas describen CDSA como:

- examen práctico de 7 días;
- investigación tipo DFIR/SOC;
- uno o varios incidentes;
- combinación de objetivos/flags y reporte;
- fuerte peso del informe final;
- necesidad de construir timeline;
- análisis de logs endpoint, Windows y red;
- uso intensivo de SIEM;
- obligación de justificar conclusiones con evidencias.

> [!NOTE]
> Los detalles exactos pueden cambiar entre versiones del examen. Usar esto como mapa de estudio, no como promesa de formato.

## Temas técnicos recurrentes

| Tema | Qué practicar |
|---|---|
| [[Elastic]] / [[Kibana]] | filtros por tiempo, host, usuario, proceso, IP, dominio, índice/data view |
| Windows logs | autenticación, procesos, servicios, tareas programadas, PowerShell |
| [[conceptos-basicos-sysmon]] | Event ID 1, 3, 7, 10, 11, 13, 22 |
| [[Zeek]] | `conn`, `dns`, `http`, `ssl`, `x509`, `files` |
| Timeline | ordenar eventos por timestamp y causalidad |
| Memoria/DFIR | interpretar evidencias de memoria si el entorno lo ofrece |
| Artefactos Windows | registro, MFT, ejecución, persistencia |
| CTI/TTPs | mapear comportamientos a MITRE ATT&CK y Cyber Kill Chain |
| Reporting | informe claro, técnico y ejecutivo |

## Herramientas mencionadas por la comunidad

| Herramienta | Uso probable de estudio |
|---|---|
| Elastic/Kibana | búsqueda y hunting en logs |
| Splunk | algunas experiencias mencionan práctica equivalente en SIEM |
| Zeek | análisis de tráfico de red |
| Volatility | memoria forense, si hay dump de memoria |
| Eric Zimmerman Tools / EZ Tools | artefactos Windows |
| KAPE | recolección y análisis de artefactos |
| SysReptor | reporte profesional con templates HTB |

> [!TIP]
> No intentes dominar todas las herramientas a nivel experto. Prioriza entender qué evidencia puede darte cada una y cómo justificar un hallazgo.

## Qué suelen decir las reviews sobre dificultad

Puntos repetidos:

- el examen es duro por amplitud y tiempo;
- el reporte pesa más de lo que parece;
- encontrar respuestas no equivale a tener el examen terminado;
- las preguntas/objetivos pueden dar pistas útiles;
- capturar evidencias desde el principio ahorra dolor al final;
- moverse si te bloqueas ayuda a no perder días en un punto;
- el path oficial cubre la base necesaria, pero conviene practicar metodología.

## Cómo estudiar sin caer en memorizar leaks

Ruta recomendada:

1. Practicar investigaciones completas en Sherlocks.
2. Escribir reportes de práctica.
3. Rehacer labs del SOC Analyst Path sin mirar soluciones.
4. Entrenar búsquedas de Windows/Sysmon/Zeek.
5. Practicar timelines.
6. Mapear TTPs a MITRE ATT&CK.
7. Preparar una plantilla de reporte.

## Mini checklist antes del examen

| Pregunta | Estado |
|---|---|
| ¿Puedo pivotar de host a proceso y de proceso a red? |  |
| ¿Puedo leer Zeek sin perderme en campos básicos? |  |
| ¿Sé explicar un Event ID de Sysmon con contexto? |  |
| ¿Sé documentar una evidencia con timestamp y fuente? |  |
| ¿Puedo redactar un resumen ejecutivo en inglés? |  |
| ¿Tengo método para timeline? |  |
| ¿Sé cuándo dejar una pregunta y volver después? |  |

## Regla mental

```text
Usa la comunidad para preparar el método, no para buscar respuestas.
```

```text
El examen evalúa investigación + reporte, no memoria de flags.
```

## Relacionado

- [[CDSA]]
- [[03-estructura-y-reglas-examen-cdsa]]
- [[04-estrategia-7-dias-cdsa]]
- [[security-incident-reporting]]
- [[fuentes-cdsa]]

