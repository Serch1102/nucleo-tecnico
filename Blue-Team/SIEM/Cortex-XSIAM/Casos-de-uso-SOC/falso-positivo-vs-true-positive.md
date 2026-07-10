# Falso positivo vs True Positive

## Definiciones

| Resultado | Significado |
|---|---|
| True Positive | La actividad detectada ocurrió y es maliciosa o requiere respuesta de seguridad. |
| False Positive | La alerta no representa actividad maliciosa ni riesgo real en ese contexto. |
| Benign True Positive | La actividad ocurrió, pero era legítima o esperada. |

## Cómo decidir

- ¿La evidencia confirma la actividad?
- ¿La actividad es esperada?
- ¿Existe justificación de negocio o cambio?
- ¿Hay impacto o intento de impacto?
- ¿Hay más señales relacionadas?
- ¿El usuario/host es crítico?

## Ejemplo

PowerShell con `-encodedcommand` ejecutado desde Word y conexión externa desconocida suele ser más riesgoso que PowerShell ejecutado por herramienta de administración corporativa con ticket de cambio.

> [!TIP]
> No cierres como FP solo porque "no pasó nada". Documenta por qué no hay riesgo o por qué la actividad es legítima.

Relacionado: [[plantilla-cierre-falso-positivo]], [[severidades-y-priorizacion]].

