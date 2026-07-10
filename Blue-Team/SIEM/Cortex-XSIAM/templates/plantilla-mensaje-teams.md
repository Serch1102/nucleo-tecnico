# Plantilla mensaje Teams

## Markdown

```markdown
**[{{severity}}] Alerta Cortex XSIAM**

- Cliente: {{client}}
- Alerta: {{alert_name}}
- Case/Issue ID: {{case_id}}
- Host: {{host}}
- Usuario: {{user}}
- IP origen/destino: {{src_ip}} -> {{dst_ip}}
- Resumen: {{summary}}
- Acción esperada: {{expected_action}}
- XSIAM: {{xsiam_link}}
```

## JSON orientativo

```json
{
  "severity": "{{severity}}",
  "client": "{{client}}",
  "alert_name": "{{alert_name}}",
  "case_id": "{{case_id}}",
  "host": "{{host}}",
  "user": "{{user}}",
  "src_ip": "{{src_ip}}",
  "dst_ip": "{{dst_ip}}",
  "summary": "{{summary}}",
  "expected_action": "{{expected_action}}",
  "xsiam_link": "{{xsiam_link}}"
}
```

> [!WARNING]
> Este JSON no debe contener la URL del webhook ni secretos.

