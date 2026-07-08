# Ejemplos de playbooks

## Notificación de alerta High/Critical

```mermaid
flowchart TD
  A["Nueva alerta"] --> B{"Severidad High/Critical?"}
  B -->|No| C["Registrar y no notificar"]
  B -->|Sí| D["Validar campos mínimos"]
  D --> E["Construir mensaje Teams"]
  E --> F["Enviar notificación"]
  F --> G["Añadir nota al case"]
```

## Enriquecimiento básico

```mermaid
flowchart TD
  A["Case creado"] --> B["Extraer host, usuario, IP, hash"]
  B --> C["Consultar reputación IOC"]
  B --> D["Consultar criticidad asset"]
  B --> E["Consultar usuario privilegiado"]
  C --> F["Actualizar case"]
  D --> F
  E --> F
```

> [!NOTE]
> Estos flujos son diseños conceptuales. La implementación exacta depende de integraciones, permisos y versión.

Relacionado: [[estructura-basica-playbook]], [[buenas-practicas]], [[evolucion-a-playbooks]].

