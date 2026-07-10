# SIEM Use Case Development

## Idea clave

Un caso de uso SIEM es una lógica de detección diseñada para identificar una situación concreta de riesgo o comportamiento sospechoso.

Puede ir desde escenarios simples, como múltiples logins fallidos, hasta casos complejos como ransomware, abuso de LoLBins, exfiltración o movimiento lateral.

## Definición

Un caso de uso SIEM es una regla, búsqueda, correlación o lógica de alerta que transforma eventos de seguridad en una señal accionable para el SOC.

> [!NOTE]
> Para un analista SOC: un caso de uso bien diseñado no solo dispara una alerta. También explica qué revisar, por qué importa y cómo decidir si es TP o FP.

## Ejemplo básico

Un usuario llamado Rob tiene 10 intentos fallidos de autenticación consecutivos.

El SIEM correlaciona esos eventos y genera una alerta bajo el caso de uso:

```text
Possible brute force against user account
```

La lógica básica sería:

```text
Si un usuario tiene >= 10 fallos de autenticación en una ventana temporal corta,
generar alerta de posible brute force.
```

## Ciclo de vida

| Fase | Descripción |
|---|---|
| Requirements | Entender la necesidad de detección |
| Data Points | Identificar fuentes de datos necesarias |
| Log Validation | Validar que los logs contienen campos útiles |
| Design | Definir condición, agregación y prioridad |
| Implementation | Implementar la regla en el SIEM |
| Documentation | Crear SOP, matriz de escalado e IRP |
| Onboarding | Probar en desarrollo antes de producción |
| Testing | Validar con datos reales o simulados |
| Fine-tuning | Reducir falsos positivos y mejorar precisión |

## 1. Requirements

Consiste en entender qué riesgo se quiere detectar.

Preguntas:

- ¿Qué amenaza queremos cubrir?
- ¿Qué comportamiento observable deja esa amenaza?
- ¿Qué impacto tendría?
- ¿Qué prioridad tiene para el negocio?

Ejemplo:

```text
Queremos detectar intentos de fuerza bruta contra cuentas corporativas.
```

## 2. Data Points

Consiste en identificar qué datos hacen falta.

Ejemplo para fuerza bruta:

- Logs de autenticación.
- Usuario.
- IP origen.
- Resultado del login.
- Timestamp.
- Host o aplicación objetivo.

## 3. Log Validation

Antes de diseñar una regla, hay que confirmar que los logs existen y contienen campos útiles.

Checklist:

- [ ] ¿Llegan los eventos al SIEM?
- [ ] ¿Tienen timestamp correcto?
- [ ] ¿Incluyen usuario?
- [ ] ¿Incluyen resultado?
- [ ] ¿Incluyen origen?
- [ ] ¿Están normalizados?

> [!WARNING]
> Si los logs no tienen los campos necesarios, el caso de uso será débil o imposible de implementar de forma fiable.

## 4. Design

En esta fase se define la lógica.

Elementos típicos:

- Condición.
- Umbral.
- Ventana temporal.
- Agrupación.
- Severidad.
- Exclusiones.
- Campos que debe mostrar la alerta.

Ejemplo:

```text
10 fallos de login por usuario en 5 minutos desde una o varias IPs.
```

## 5. Implementation

Consiste en crear la regla en el SIEM.

En Elastic puede implicar:

- Query KQL.
- Regla de detección.
- Threshold rule.
- Timeline o dashboard de apoyo.

> [!NOTE]
> TODO: validar en laboratorio el tipo exacto de regla según versión/licencia de Elastic Security.

## 6. Documentation

Un caso de uso sin documentación suele generar dependencia del analista que lo creó.

Documentar:

- Objetivo de la detección.
- Query o lógica.
- Campos relevantes.
- Severidad.
- Mapeo MITRE.
- SOP.
- IRP.
- Matriz de escalado.
- Criterios TP/FP.
- Fine-tuning aplicado.

## 7. Onboarding

Antes de producción, probar en entorno controlado.

Validar:

- Que la regla dispara cuando debe.
- Que no genera volumen excesivo.
- Que el mensaje de alerta es entendible.
- Que el SOC sabe qué hacer.

## 8. Testing

Probar con datos reales o simulados.

Ejemplos:

- Reproducir 10 fallos de login.
- Simular actividad de LoLBin.
- Usar logs históricos.
- Comparar con incidentes conocidos.

## 9. Fine-tuning

Reducir falsos positivos sin perder cobertura.

Técnicas:

- Allowlist de sistemas legítimos.
- Baseline por usuario, host o departamento.
- Umbrales diferentes por criticidad.
- Exclusión de cuentas técnicas conocidas.
- Enriquecimiento con contexto de assets.

## Cómo construir casos de uso SIEM

Checklist general:

- [ ] Comprender riesgos y necesidades.
- [ ] Determinar prioridad e impacto.
- [ ] Mapear a MITRE ATT&CK o Kill Chain.
- [ ] Definir Time To Detection, TTD.
- [ ] Definir Time To Response, TTR.
- [ ] Crear SOP.
- [ ] Crear Incident Response Plan, IRP.
- [ ] Definir SLA/OLA.
- [ ] Crear proceso de auditoría.
- [ ] Documentar frecuencia de disparo y calidad de logs.
- [ ] Mantener base de conocimiento para analistas.

## Uso en SOC

| Elemento | Por qué importa |
|---|---|
| Query | Define qué se detecta |
| Severidad | Ayuda a priorizar |
| SOP | Guía la investigación |
| IRP | Define respuesta ante incidente |
| Fine-tuning | Reduce ruido |
| MITRE ATT&CK | Conecta la detección con comportamiento adversario |

## Notas para CDSA

- Una buena detección empieza por una hipótesis clara.
- No diseñes reglas sin validar los datos.
- Documenta la lógica como si otra persona tuviera que operarla a las 03:00.
- Fine-tuning no es ocultar alertas: es mejorar señal.

Relacionado: [[02-kql-para-soc]], [[04-ejemplos-deteccion-msbuild]].

