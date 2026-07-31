# Registros de eventos de Windows útiles

## Idea clave

Los eventos de Windows ayudan a reconstruir qué ocurrió en un sistema: inicios de sesión, cambios de configuración, ejecución de servicios, tareas programadas, actividad de Defender, accesos a recursos compartidos y posibles intentos de ocultación.

Esta entrada no pretende memorizar todos los Event IDs. La idea es tener una lista práctica para orientar investigaciones SOC.

> [!NOTE]
> Para un analista SOC: un Event ID por sí solo rara vez confirma un incidente. Lo importante es correlacionarlo con usuario, host, hora, proceso, origen, destino y actividad cercana.

## Vista rápida por categoría

| Categoría | Event IDs útiles | Qué mirar |
|---|---|---|
| Sistema | `1074`, `6005`, `6006`, `6013`, `7040` | Apagados, reinicios, servicio de logs, cambios de servicios |
| Autenticación | `4624`, `4625`, `4648`, `4771`, `4776` | Logons, fallos, credenciales explícitas, Kerberos, DC |
| Privilegios y cuentas | `4672`, `4738` | Privilegios especiales y cambios de usuarios |
| Auditoría | `1102`, `4719` | Borrado de logs y cambios de política de auditoría |
| Defender / AV | `1116`, `1118`, `1119`, `1120`, `5001` | Malware, remediación y cambios de protección |
| Persistencia | `4698`, `4700`, `4701`, `4702`, `7045` | Tareas programadas y servicios nuevos |
| Recursos compartidos / red | `5140`, `5142`, `5145`, `5157` | Shares, accesos y conexiones bloqueadas |

> [!WARNING]
> La disponibilidad de eventos depende de políticas de auditoría, configuración de Windows, versión del sistema, Sysmon/EDR, forwarding y normalización en el SIEM.

---

## Eventos de sistema

| Event ID | Qué significa | Por qué importa en SOC |
|---|---|---|
| `1074` | Apagado o reinicio iniciado | Puede ayudar a identificar reinicios inesperados o actividad de mantenimiento no autorizada |
| `6005` | El servicio de registro de eventos se inició | Suele indicar arranque del sistema o reinicio del servicio de eventos |
| `6006` | El servicio de registro de eventos se detuvo | Normal en apagado ordenado, sospechoso si ocurre fuera de contexto |
| `6013` | Tiempo de actividad del sistema | Ayuda a confirmar uptime y reinicios recientes |
| `7040` | Cambio en configuración de inicio de un servicio | Puede indicar manipulación de servicios |

## Uso en SOC

Estos eventos sirven para responder:

- ¿El equipo se reinició durante la ventana del incidente?
- ¿El servicio de logs se detuvo de forma inesperada?
- ¿Alguien cambió cómo arranca un servicio?
- ¿El reinicio coincide con instalación, malware o actividad administrativa?

---

## Eventos de autenticación

| Event ID | Qué significa | Por qué importa en SOC |
|---|---|---|
| `4624` | Inicio de sesión correcto | Permite validar accesos legítimos o sospechosos |
| `4625` | Fallo de inicio de sesión | Útil para fuerza bruta, password spraying o credenciales antiguas |
| `4648` | Logon con credenciales explícitas | Puede aparecer en uso administrativo o movimiento lateral |
| `4771` | Error de preautenticación Kerberos | Puede indicar contraseña incorrecta o ataques contra Kerberos |
| `4776` | El DC validó credenciales | Ayuda a rastrear validaciones NTLM exitosas o fallidas |

## Uso en SOC

Preguntas útiles:

- ¿Quién inició sesión?
- ¿Desde dónde?
- ¿En qué equipo?
- ¿Fue un logon interactivo, remoto, servicio o red?
- ¿Hubo muchos fallos antes de un éxito?
- ¿Se usaron credenciales explícitas de forma inusual?

> [!TIP]
> En investigaciones de autenticación, revisa también tipo de logon, host origen, cuenta objetivo, controlador de dominio y ventana temporal.

---

## Privilegios y cuentas

| Event ID | Qué significa | Por qué importa en SOC |
|---|---|---|
| `4672` | Privilegios especiales asignados a un nuevo logon | Indica inicio de sesión con privilegios elevados |
| `4738` | Cuenta de usuario modificada | Puede reflejar cambios de privilegios, atributos o configuración de cuenta |

## Uso en SOC

Estos eventos ayudan a detectar:

- Uso de cuentas privilegiadas.
- Cambios inesperados en usuarios.
- Posible abuso de privilegios.
- Modificaciones posteriores a una cuenta comprometida.

---

## Auditoría y posible ocultación

| Event ID | Qué significa | Por qué importa en SOC |
|---|---|---|
| `1102` | El registro de auditoría fue borrado | Señal fuerte de posible intento de ocultar actividad |
| `4719` | Cambio en la política de auditoría | Puede indicar intento de reducir visibilidad |

## Uso en SOC

Si aparece `1102`, revisa inmediatamente:

- Usuario que ejecutó la acción.
- Host afectado.
- Actividad previa al borrado.
- Logons recientes.
- Cambios de privilegios.
- Eventos del SIEM/EDR alrededor de la misma hora.

> [!WARNING]
> Borrar logs no siempre confirma compromiso, pero en un SOC debe tratarse como evento de alta prioridad hasta entender el contexto.

---

## Defender y antivirus

| Event ID | Qué significa | Por qué importa en SOC |
|---|---|---|
| `1116` | Defender detectó malware | Indica detección de amenaza |
| `1118` | Remediación iniciada | Defender empezó limpieza o cuarentena |
| `1119` | Remediación exitosa | La amenaza se neutralizó correctamente |
| `1120` | Remediación fallida | La amenaza puede seguir presente |
| `5001` | Cambio en protección en tiempo real | Puede indicar intento de debilitar Defender |

## Uso en SOC

Preguntas útiles:

- ¿Qué amenaza detectó Defender?
- ¿En qué ruta estaba el archivo?
- ¿La remediación terminó bien?
- ¿Hubo ejecución antes de la detección?
- ¿Se cambió la protección en tiempo real?

---

## Persistencia: tareas programadas y servicios

| Event ID | Qué significa | Por qué importa en SOC |
|---|---|---|
| `4698` | Tarea programada creada | Técnica habitual de persistencia |
| `4700` | Tarea programada activada | Puede indicar ejecución programada |
| `4701` | Tarea programada desactivada | Puede indicar manipulación |
| `4702` | Tarea programada actualizada | Cambios sospechosos en persistencia |
| `7045` | Servicio instalado en el sistema | Puede indicar instalación legítima o malware como servicio |

## Uso en SOC

Revisar:

- Nombre de la tarea o servicio.
- Comando ejecutado.
- Usuario que lo creó.
- Ruta del binario.
- Firma del binario.
- Proceso padre si está disponible.
- Si coincide con cambios autorizados.

> [!TIP]
> Tareas programadas y servicios son dos mecanismos clásicos para persistencia. Si aparecen en un host durante una alerta, revisa qué ejecutan y quién los creó.

---

## Recursos compartidos y red

| Event ID | Qué significa | Por qué importa en SOC |
|---|---|---|
| `5140` | Acceso a recurso compartido de red | Ayuda a investigar acceso a shares |
| `5142` | Recurso compartido creado | Puede indicar share no autorizado |
| `5145` | Comprobación de acceso a share | Útil para intentos repetidos o enumeración |
| `5157` | Windows Filtering Platform bloqueó una conexión | Ayuda a ver tráfico bloqueado localmente |

## Uso en SOC

Preguntas útiles:

- ¿Qué recurso compartido se accedió?
- ¿Desde qué usuario/equipo?
- ¿Se creó un share nuevo?
- ¿Hay muchos intentos de acceso?
- ¿El firewall local bloqueó conexiones sospechosas?

---

## Mini-checklist de investigación

Cuando encuentres un Event ID relevante:

- [ ] Identificar host.
- [ ] Identificar usuario.
- [ ] Revisar timestamp.
- [ ] Revisar origen/destino si aplica.
- [ ] Buscar eventos anteriores y posteriores.
- [ ] Correlacionar con EDR, SIEM, proxy, DNS o firewall.
- [ ] Validar si existe cambio aprobado.
- [ ] Documentar decisión: True Positive, False Positive o Benign True Positive.

## Baseline y falsos positivos

Lo normal cambia según el entorno.

Ejemplos:

- `7045` puede ser normal durante despliegues de software.
- `4698` puede ser normal en herramientas de administración.
- `4625` puede aparecer por contraseñas antiguas en servicios.
- `4672` puede ser normal en cuentas administrativas.
- `5157` puede ser ruido si hay políticas locales muy restrictivas.

> [!NOTE]
> La clave no es alertar por cada evento individual. La clave es detectar combinaciones, frecuencia, contexto y anomalías.

## Ejemplos de correlación SOC

| Patrón | Interpretación posible |
|---|---|
| `4625` repetido + `4624` exitoso | Fuerza bruta seguida de acceso válido |
| `4648` + acceso SMB | Posible uso de credenciales para movimiento lateral |
| `1102` después de logon privilegiado | Posible borrado de evidencias |
| `4698` o `7045` tras documento sospechoso | Posible persistencia |
| `1116` + `1120` | Malware detectado pero no remediado |
| `5001` + detección malware | Posible intento de debilitar protección |

## Resumen final

```text
4624 / 4625 -> autenticación
4648 -> credenciales explícitas
4672 -> privilegios elevados
4698 / 4700 / 4701 / 4702 -> tareas programadas
7045 -> servicio instalado
1102 / 4719 -> auditoría y posible ocultación
1116-1120 / 5001 -> Defender y malware
5140 / 5142 / 5145 -> recursos compartidos
5157 -> conexión bloqueada
6005 / 6006 / 6013 / 1074 -> arranque, apagado y uptime
```

La idea más importante:

> Un Event ID es una pista. La investigación SOC empieza cuando lo conectas con contexto.

Relacionado: [[Windows]], [[SIEM]], [[Elastic]], [[Cortex-XSIAM]].

