# CDSA

Mapa de preparación para el examen final de **HTB Certified Defensive Security Analyst (CDSA)** y uso del voucher.

> [!WARNING]
> Esta sección es una guía de estudio personal. El formato exacto del examen, condiciones del voucher, tiempos, intentos y requisitos pueden cambiar. Validar siempre en la documentación oficial de Hack The Box Academy antes de reservar o iniciar el examen.

## Entradas principales

| Nota | Uso |
|---|---|
| [[00-examen-final-y-voucher-cdsa]] | Entender cómo preparar el tramo final sin asumir detalles no verificados |
| [[01-metodologia-investigacion-cdsa]] | Método paso a paso para investigar evidencias durante el examen |
| [[02-checklist-hunting-elastic-windows-zeek]] | Checklist práctico para hunting con Elastic, Windows, Sysmon, PowerShell y Zeek |
| [[plantilla-respuesta-examen-cdsa]] | Plantilla para documentar respuestas y evidencias |

## Mapa mental

```mermaid
flowchart LR
  CDSA["CDSA"] --> SIEM["SIEM"]
  CDSA --> Elastic["Elastic"]
  CDSA --> Windows["Windows"]
  CDSA --> Redes["Redes"]
  CDSA --> CTI["Threat Intelligence"]
  CDSA --> DE["Detection Engineering"]
  Elastic --> Kibana["Kibana"]
  Redes --> Zeek["Zeek"]
  Windows --> Sysmon["Sysmon"]
```

Relacionado: [[Blue-Team]], [[SIEM]], [[Elastic]], [[Kibana]], [[Windows]], [[conceptos-basicos-sysmon]], [[Zeek]], [[Threat-Intelligence]], [[Detection-Engineering]].

