# Modelo OSI

## Idea clave

El modelo OSI es una forma de ordenar cómo se comunica un sistema con otro a través de una red.

No es una herramienta ni un protocolo concreto. Es un modelo mental dividido en 7 capas que ayuda a entender dónde ocurre cada parte de una comunicación.

```text
7. Aplicación
6. Presentación
5. Sesión
4. Transporte
3. Red
2. Enlace de datos
1. Física
```

> [!NOTE]
> Para un analista SOC: OSI te ayuda a ubicar una alerta. No es lo mismo investigar un dominio HTTP, una sesión TLS, un puerto TCP, una IP, una MAC o un cable desconectado.

## Explicación de alto nivel

Imagina que un usuario abre una web:

```text
Usuario abre https://example.com
-> El navegador genera una petición
-> Los datos se formatean y cifran
-> Se establece una sesión
-> TCP controla la comunicación
-> IP decide el camino entre redes
-> Ethernet/Wi-Fi entrega tramas en la red local
-> La señal viaja por cable, fibra o radio
```

Cada capa tiene una responsabilidad distinta.

## Vista rápida

| Capa | Nombre | Pregunta sencilla | Ejemplos |
|---|---|---|---|
| 7 | Aplicación | ¿Qué quiere hacer el usuario o programa? | HTTP, DNS, SMTP, SSH |
| 6 | Presentación | ¿Cómo se representa o protege el dato? | TLS, cifrado, compresión, encoding |
| 5 | Sesión | ¿Cómo se mantiene la conversación? | Sesiones, autenticación, control de diálogo |
| 4 | Transporte | ¿Cómo se entrega entre procesos? | TCP, UDP, puertos |
| 3 | Red | ¿Cómo se enruta entre redes? | IP, ICMP, routing |
| 2 | Enlace de datos | ¿Cómo se entrega en la red local? | Ethernet, Wi-Fi, MAC, VLAN |
| 1 | Física | ¿Cómo viaja la señal? | Cable, fibra, radio, conectores |

## Analogía sencilla

Enviar datos por red se parece a enviar un paquete:

| Capa OSI | Analogía |
|---|---|
| Aplicación | Escribir el mensaje |
| Presentación | Ponerlo en un idioma/formato que el otro entienda |
| Sesión | Mantener una conversación abierta |
| Transporte | Dividirlo en partes y confirmar entrega |
| Red | Elegir la ruta entre ciudades |
| Enlace | Entregarlo dentro del barrio correcto |
| Física | La carretera, vehículo o cable por donde viaja |

## De alto nivel a bajo nivel

Cuando investigas desde la experiencia del usuario hacia la infraestructura, normalmente bajas por las capas:

```text
Aplicación -> Presentación -> Sesión -> Transporte -> Red -> Enlace -> Física
```

Cuando haces troubleshooting desde conectividad básica, normalmente subes:

```text
Física -> Enlace -> Red -> Transporte -> Sesión -> Presentación -> Aplicación
```

> [!TIP]
> Si una aplicación no funciona, no empieces siempre por la capa 7. Primero confirma si hay conectividad básica: enlace, IP, ruta, puerto y luego aplicación.

---

## Capa 7: Aplicación

### Qué es

Es la capa más cercana al usuario y a las aplicaciones.

Aquí viven los protocolos que permiten hacer cosas concretas:

- Navegar por una web.
- Resolver un dominio.
- Enviar correo.
- Acceder por SSH.
- Transferir archivos.

### Ejemplos

| Protocolo | Uso |
|---|---|
| HTTP/HTTPS | Navegación web y APIs |
| DNS | Resolución de nombres |
| SMTP | Envío de correo |
| IMAP/POP3 | Lectura de correo |
| SSH | Administración remota |
| FTP/SFTP | Transferencia de archivos |

### Uso en SOC

En capa 7 investigas preguntas como:

- ¿Qué dominio visitó el host?
- ¿Qué URL se solicitó?
- ¿Qué usuario inició sesión en una aplicación?
- ¿Qué comando se ejecutó por SSH?
- ¿Qué tipo de petición HTTP se observó?

### Logs habituales

- Proxy.
- WAF.
- DNS.
- Aplicaciones.
- API gateway.
- Servidores web.

---

## Capa 6: Presentación

### Qué es

Se encarga del formato de los datos, codificación, compresión y cifrado.

Es la capa que responde:

```text
¿Los datos están en un formato que el otro sistema puede entender?
¿Van cifrados?
¿Están comprimidos?
```

### Ejemplos

| Elemento | Uso |
|---|---|
| TLS/SSL | Cifrado de comunicaciones |
| JSON/XML | Formato de intercambio de datos |
| Base64 | Codificación |
| Gzip | Compresión |
| UTF-8 | Codificación de texto |

### Uso en SOC

En capa 6 revisas:

- Certificados TLS.
- Versiones TLS débiles.
- Datos codificados en Base64.
- Payloads comprimidos.
- Problemas de inspección por tráfico cifrado.

> [!WARNING]
> Muchas veces el tráfico cifrado impide ver contenido de capa 7 si no hay inspección TLS autorizada.

---

## Capa 5: Sesión

### Qué es

Gestiona la apertura, mantenimiento y cierre de conversaciones entre sistemas.

No siempre aparece de forma clara en herramientas modernas, pero el concepto sigue siendo útil.

### Ejemplos conceptuales

- Login de usuario.
- Token de sesión.
- Cookie de sesión.
- Reautenticación.
- Timeout de sesión.
- Control de diálogo cliente-servidor.

### Uso en SOC

En capa 5 te interesan preguntas como:

- ¿Cuándo empezó la sesión?
- ¿Cuándo terminó?
- ¿Desde qué IP se creó?
- ¿La sesión se reutilizó desde otra ubicación?
- ¿Hubo secuestro o reutilización de token?

### Logs habituales

- IAM.
- VPN.
- Aplicaciones SaaS.
- Portales web.
- Sistemas de autenticación.

---

## Capa 4: Transporte

### Qué es

Se encarga de la comunicación entre procesos usando puertos.

Los protocolos principales son:

- TCP.
- UDP.

### TCP

TCP es orientado a conexión. Busca entrega fiable.

Ejemplos:

- HTTP/HTTPS.
- SSH.
- SMTP.
- RDP.

### UDP

UDP no establece conexión como TCP. Es más simple y rápido, pero no garantiza entrega.

Ejemplos:

- DNS.
- NTP.
- VoIP.
- Algunos túneles VPN.

### Conceptos clave

| Concepto | Significado |
|---|---|
| Puerto origen | Puerto usado por el cliente |
| Puerto destino | Servicio al que se conecta |
| TCP handshake | Establecimiento de conexión TCP |
| SYN | Intento de iniciar conexión |
| RST | Reinicio o rechazo de conexión |
| Timeout | Sin respuesta o comunicación incompleta |

### Uso en SOC

Preguntas típicas:

- ¿A qué puerto conectó el host?
- ¿Hubo muchos SYN sin completar?
- ¿El puerto destino es raro?
- ¿Hay conexiones salientes a puertos no habituales?
- ¿Un proceso abrió un puerto de escucha?

### Ejemplos SOC

| Señal | Posible interpretación |
|---|---|
| Muchas conexiones a `3389/TCP` | Escaneo o intento RDP |
| Muchas consultas `53/UDP` | DNS normal o túnel DNS |
| Salida a `4444/TCP` | Posible reverse shell, depende del contexto |
| `445/TCP` entre muchos hosts | SMB, posible movimiento lateral |

---

## Capa 3: Red

### Qué es

Se encarga del direccionamiento y enrutamiento entre redes.

Aquí vive IP.

### Conceptos clave

| Concepto | Significado |
|---|---|
| IP origen | Sistema que envía |
| IP destino | Sistema que recibe |
| Router | Equipo que conecta redes |
| Subred | Rango lógico de IPs |
| Gateway | Salida hacia otras redes |
| ICMP | Protocolo usado, por ejemplo, en ping |

### Uso en SOC

Preguntas típicas:

- ¿Qué IP origen generó el tráfico?
- ¿Qué IP destino recibió la conexión?
- ¿Es una IP interna o externa?
- ¿A qué país/ASN pertenece una IP pública?
- ¿Hay comunicación entre segmentos que no deberían hablar?

### Logs habituales

- Firewall.
- NetFlow.
- VPN.
- IDS/IPS.
- Cloud network logs.

> [!TIP]
> En SOC, IP no siempre identifica una máquina única. Puede haber NAT, proxies, VPNs, balanceadores o direcciones compartidas.

---

## Capa 2: Enlace de datos

### Qué es

Se encarga de la comunicación dentro de una red local.

Aquí aparecen conceptos como:

- MAC address.
- Switches.
- VLAN.
- ARP.
- Tramas Ethernet.
- Wi-Fi a nivel local.

### Conceptos clave

| Concepto | Significado |
|---|---|
| MAC | Identificador de interfaz de red |
| Switch | Conecta equipos dentro de una LAN |
| VLAN | Segmentación lógica de red local |
| ARP | Relaciona IP con MAC en una LAN |
| Trama | Unidad de datos de capa 2 |

### Uso en SOC

Preguntas típicas:

- ¿Qué MAC tenía un equipo?
- ¿En qué VLAN estaba?
- ¿Hubo ARP spoofing?
- ¿Hay cambios raros de MAC?
- ¿Un host apareció en un segmento que no corresponde?

### Señales de riesgo

- ARP spoofing.
- MAC flapping.
- VLAN hopping.
- Dispositivos no autorizados.
- Cambios inesperados de switchport.

---

## Capa 1: Física

### Qué es

Es la capa del medio físico por donde viaja la señal.

Incluye:

- Cableado.
- Fibra.
- Radiofrecuencia.
- Conectores.
- Señal eléctrica u óptica.
- Potencia de señal Wi-Fi.

### Uso en SOC y operaciones

En SOC puro se ve menos que otras capas, pero importa en:

- Cortes de conectividad.
- Dispositivos desconectados.
- Problemas de enlace.
- Puntos de acceso no autorizados.
- Manipulación física.

### Preguntas típicas

- ¿El equipo tiene enlace físico?
- ¿El puerto del switch está activo?
- ¿Hay pérdida de señal?
- ¿Hay interferencia Wi-Fi?
- ¿Se conectó un dispositivo no autorizado?

---

## Encapsulación

Cuando un dato baja por las capas, cada capa añade información.

```text
Datos de aplicación
-> Segmento TCP/UDP
-> Paquete IP
-> Trama Ethernet/Wi-Fi
-> Bits/señal física
```

Cuando llega al destino, el proceso se invierte.

```text
Bits
-> Trama
-> Paquete IP
-> Segmento TCP/UDP
-> Datos de aplicación
```

## OSI vs TCP/IP

En la práctica también se usa el modelo TCP/IP, que agrupa capas.

| OSI | TCP/IP aproximado |
|---|---|
| 7 Aplicación | Aplicación |
| 6 Presentación | Aplicación |
| 5 Sesión | Aplicación |
| 4 Transporte | Transporte |
| 3 Red | Internet |
| 2 Enlace | Acceso a red |
| 1 Física | Acceso a red |

> [!NOTE]
> OSI ayuda a estudiar y razonar. TCP/IP se acerca más a cómo se implementan muchas redes reales.

## Cómo usar OSI durante una investigación SOC

### Caso: alerta de conexión sospechosa

| Capa | Qué revisar |
|---|---|
| 7 Aplicación | Dominio, URL, método, usuario, proceso asociado |
| 6 Presentación | TLS, certificado, cifrado, SNI si existe |
| 5 Sesión | Login, token, duración, reutilización de sesión |
| 4 Transporte | Puerto, TCP/UDP, frecuencia, handshake |
| 3 Red | IP origen/destino, geolocalización, ASN, routing |
| 2 Enlace | MAC, VLAN, segmento local |
| 1 Física | Enlace físico, Wi-Fi, desconexiones |

## Regla práctica

Si ves un dato, intenta ubicarlo:

| Dato observado | Capa más relacionada |
|---|---|
| URL | 7 Aplicación |
| Dominio DNS | 7 Aplicación |
| Certificado TLS | 6 Presentación |
| Cookie/token | 5 Sesión |
| Puerto `443/TCP` | 4 Transporte |
| IP `8.8.8.8` | 3 Red |
| MAC address | 2 Enlace |
| Cable desconectado | 1 Física |

## Errores comunes

- Confundir puerto con aplicación. `443/TCP` suele ser HTTPS, pero puede transportar otra cosa.
- Pensar que una IP pública identifica siempre a un usuario. Puede haber NAT, proxy o VPN.
- Ignorar DNS. Muchas investigaciones empiezan con IP, pero el dominio puede dar más contexto.
- Investigar solo capa 7 sin validar conectividad.
- Investigar solo IP/puerto sin mirar proceso, usuario y contexto.

## Resumen final

```text
Capa 7: Qué quiere hacer la aplicación.
Capa 6: Cómo se representa/cifra el dato.
Capa 5: Cómo se mantiene la sesión.
Capa 4: Qué puerto/protocolo transporta.
Capa 3: Qué IP enruta entre redes.
Capa 2: Qué MAC/VLAN entrega en red local.
Capa 1: Qué medio físico transporta la señal.
```

La idea más importante:

> El modelo OSI no se memoriza para recitarlo. Se usa para ordenar problemas, investigaciones y evidencias.

Relacionado: [[README]], [[SIEM]].

