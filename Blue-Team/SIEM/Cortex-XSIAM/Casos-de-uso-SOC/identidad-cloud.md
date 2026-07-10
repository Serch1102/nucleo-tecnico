# Caso de uso SOC: Identidad cloud

## Qué significa

Actividad sospechosa relacionada con cuentas cloud, inicio de sesión, privilegios o acceso anómalo.

## Qué revisar

- Usuario afectado.
- IP origen y geolocalización si está disponible.
- MFA aplicado o fallido.
- Dispositivo usado.
- Cambios de privilegios.
- Acceso a recursos sensibles.

## Query útil orientativa

```xql
// Orientativo: usar dataset cloud/identity real disponible en el tenant.
dataset = identity_events
| filter user_name contains "usuario"
| fields _time, user_name, src_ip, action, result, application
| sort desc _time
| limit 100
```

## Señales de riesgo

- Login imposible geográficamente.
- MFA fatigue o múltiples fallos.
- Elevación de privilegios.
- Acceso desde IP anónima o no habitual.

## Señales de falso positivo

- Viaje validado.
- VPN corporativa.
- Cambio aprobado.
- Proveedor administrado conocido.

## Decisión recomendada

Si hay acceso exitoso sospechoso y cambios de privilegio, escalar y recomendar reset de credenciales o revisión de sesión.

## Ejemplo de cierre

El acceso provino de IP de VPN corporativa validada. MFA exitoso y sin cambios de privilegios. Se cierra como False Positive.

