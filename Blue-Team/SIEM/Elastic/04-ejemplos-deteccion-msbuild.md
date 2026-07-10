# Ejemplos de detección: MSBuild

## Idea clave

`MSBuild.exe` forma parte de Microsoft Build Engine. Puede compilar aplicaciones usando archivos XML o proyectos de build.

Los atacantes pueden abusar de MSBuild como LoLBin para ejecutar código malicioso mediante configuración o archivos de proyecto.

> [!NOTE]
> LoLBin significa Living off the Land Binary: binario legítimo del sistema o entorno que puede ser abusado para ejecutar acciones maliciosas.

## Ejemplo 1: Microsoft Build Engine iniciado por Office

Nombre de detección:

```text
MSBuild started by Office Application
```

### Qué detecta

Detecta cuando una aplicación de Office, como Word o Excel, inicia `msbuild.exe`.

### Riesgo

Si Word o Excel lanzan MSBuild, puede indicar:

- Ejecución de payload malicioso.
- Abuso de macros o documentos maliciosos.
- Uso de MSBuild como proxy execution.
- Actividad asociada a LoLBins.

### Mapeo MITRE

| Campo | Valor |
|---|---|
| Táctica | Defense Evasion, TA0005 |
| Técnica | Trusted Developer Utilities Proxy Execution, T1127 |
| Subtécnica | MSBuild, T1127.001 |
| Relación adicional | Execution, TA0002 |

> [!WARNING]
> Validar mapeo y nombres actuales con MITRE ATT&CK oficial antes de usar en documentación formal.

### Severidad sugerida

```text
HIGH
```

Especialmente si:

- El usuario no es desarrollador.
- No existe baseline legítimo.
- El host no es una estación de desarrollo.
- Hay conexión de red posterior.
- El proceso padre es Office.

### Campos a revisar en SOP

| Campo | Pregunta SOC |
|---|---|
| `process.name` | ¿El proceso es `msbuild.exe`? |
| `process.parent.name` | ¿Lo lanzó Word, Excel u otra app de Office? |
| `event.action` | ¿Qué acción registró el endpoint? |
| host/machine afectada | ¿Qué equipo ejecutó MSBuild? |
| usuario asociado | ¿Quién estaba usando el equipo? |
| actividad del usuario +/- 2 días | ¿Hay patrón previo o posterior? |
| logs de endpoint | ¿Qué procesos relacionados aparecen? |
| logs antivirus/EDR | ¿Hubo bloqueo o alerta adicional? |
| logs proxy | ¿Hubo conexión a dominios/IP sospechosos? |
| conexiones de red relacionadas | ¿MSBuild o proceso hijo conectó fuera? |

### KQL orientativa

```kql
process.name: "msbuild.exe" AND process.parent.name: ("winword.exe" OR "excel.exe" OR "powerpnt.exe" OR "outlook.exe")
```

> [!WARNING]
> Esta query es orientativa. Los nombres de campos dependen de la fuente, ECS, agente y pipeline. TODO: validar en laboratorio.

### Flujo de investigación

1. Confirmar proceso `msbuild.exe`.
2. Revisar proceso padre.
3. Revisar línea de comandos.
4. Identificar usuario y host.
5. Revisar actividad del usuario +/- 2 días.
6. Buscar documentos Office recientes.
7. Revisar conexiones de red.
8. Buscar alertas EDR/AV relacionadas.
9. Decidir TP/FP.

### Fine-tuning

Excluir casos legítimos de:

- Desarrolladores.
- Servidores de build.
- Herramientas internas.
- Hosts con baseline conocido.

Hacer baseline por:

- Departamento.
- Usuario.
- Host.
- Ruta del binario.
- Proceso padre esperado.

## Ejemplo 2: MSBuild haciendo conexiones de red

Nombre de detección:

```text
MSBuild making network connections
```

### Qué detecta

Detecta cuando `msbuild.exe` establece conexiones salientes hacia IPs remotas o dominios.

### Riesgo

Puede indicar ejecución de código mediante LoLBin con comunicación externa.

Escenarios posibles:

- Descarga de payload.
- Comunicación con infraestructura maliciosa.
- Abuso de MSBuild desde proyecto malicioso.
- Actividad posterior a documento malicioso o script.

### Severidad sugerida

```text
MEDIUM
```

Motivo: puede haber falsos positivos si MSBuild contacta con infraestructura legítima, especialmente en entornos de desarrollo.

Subir severidad si:

- El destino tiene mala reputación.
- El usuario no es desarrollador.
- El host no pertenece a entorno de build.
- Hay alerta EDR relacionada.
- Existe proceso padre sospechoso.

### Campos clave

| Campo | Pregunta SOC |
|---|---|
| `process.name` | ¿El proceso es `msbuild.exe`? |
| `event.action` | ¿La acción es conexión de red? |
| `destination.ip` | ¿A qué IP conecta? |
| `destination.domain` | ¿Qué dominio está implicado? |
| reputación de IP/dominio | ¿Hay threat intelligence? |
| usuario | ¿Quién ejecutó el proceso? |
| host | ¿Desde qué equipo? |
| parent process | ¿Qué lanzó MSBuild? |
| línea de comandos | ¿Qué archivo/proyecto ejecutó? |
| relación con threat intelligence | ¿Hay IOC conocido? |

### KQL orientativa

```kql
process.name: "msbuild.exe" AND event.action: *network*
```

Versión más concreta si existen campos de destino:

```kql
process.name: "msbuild.exe" AND (destination.ip:* OR destination.domain:*)
```

> [!WARNING]
> `event.action:*network*` es orientativo y puede no funcionar igual en todos los datasets. Validar nombres de eventos/campos reales.

### Flujo de investigación

1. Confirmar que `msbuild.exe` generó actividad de red.
2. Revisar destino IP/dominio.
3. Validar reputación.
4. Revisar proceso padre.
5. Revisar línea de comandos.
6. Confirmar si el usuario/host pertenece a desarrollo.
7. Buscar actividad similar en otros hosts.
8. Revisar descargas o procesos posteriores.

### Fine-tuning

Cruzar con:

- Reputación de IP.
- Reputación de dominio.
- Allowlist de dominios legítimos.
- Contexto de usuario.
- Baseline de hosts de desarrollo.
- Rutas conocidas de herramientas de build.

## Uso en SOC

| Señal | Interpretación |
|---|---|
| Office -> MSBuild | Riesgo alto de abuso por documento malicioso |
| MSBuild -> red externa | Posible descarga o comunicación externa |
| MSBuild en equipo de desarrollo | Puede ser legítimo, requiere baseline |
| MSBuild con destino malicioso | Escalar prioridad |
| MSBuild con parent sospechoso | Revisar como posible ejecución maliciosa |

## Notas para CDSA

- MSBuild es un buen ejemplo de LoLBin porque es legítimo y puede ser abusado.
- No cierres por nombre de proceso: revisa parent, command line, usuario, host y red.
- La detección mejora mucho al combinar proceso + parent + destino + contexto del usuario.
- Documenta siempre criterios de falso positivo.

## TODO

- TODO: validar queries KQL con dataset Elastic real.
- TODO: ajustar campos a ECS usado en laboratorio.
- TODO: añadir ejemplos de alert document y SOP completo.

Relacionado: [[03-use-case-development-siem]], [[02-kql-para-soc]].

