# Formato de mensaje Teams

## Campos mínimos

| Campo | Ejemplo |
|---|---|
| Severidad | High |
| Cliente | Cliente A |
| Nombre de alerta | Suspicious PowerShell Execution |
| Case/Issue ID | CASE-12345 |
| Host | HOST-001 |
| Usuario | dominio\\usuario |
| IP origen | 10.0.1.10 |
| IP destino | 8.8.8.8 |
| Resumen | PowerShell ejecutado con parámetros sospechosos. |
| Acción esperada | Revisar case y validar legitimidad. |
| Link a XSIAM | URL interna del case. |

## Plantilla Markdown

```markdown
**[High] Alerta Cortex XSIAM**

- Cliente: Cliente A
- Alerta: Suspicious PowerShell Execution
- Case/Issue ID: CASE-12345
- Host: HOST-001
- Usuario: dominio\usuario
- IP origen/destino: 10.0.1.10 -> 8.8.8.8
- Resumen: PowerShell ejecutado con parámetros sospechosos.
- Acción esperada: revisar case y validar si corresponde a actividad legítima.
- XSIAM: https://xsiam.example/case/CASE-12345
```

> [!WARNING]
> No incluir tokens, credenciales, datos personales innecesarios ni URLs de webhook en el mensaje.

Relacionado: [[plantilla-mensaje-teams]], [[mensaje-alerta-high]], [[adaptive-card-basica]].

