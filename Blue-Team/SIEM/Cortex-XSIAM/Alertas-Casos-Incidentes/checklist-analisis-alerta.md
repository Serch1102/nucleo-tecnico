# Checklist de análisis de alerta

Usa este checklist antes de cerrar una alerta.

## Identificación

- [ ] Nombre de alerta revisado.
- [ ] Severidad revisada.
- [ ] Case/Incident ID anotado.
- [ ] Host afectado identificado.
- [ ] Usuario implicado identificado.
- [ ] Timestamp inicial y final revisados.

## Evidencia

- [ ] Evento que disparó la alerta localizado.
- [ ] Línea de comandos revisada si aplica.
- [ ] Hash, ruta o fichero revisado si aplica.
- [ ] IP origen/destino revisada si aplica.
- [ ] Eventos cercanos buscados con XQL.

## Contexto

- [ ] Entidad crítica o no crítica.
- [ ] Usuario privilegiado o estándar.
- [ ] Actividad esperada o inusual.
- [ ] Coincidencias con otras alertas.
- [ ] IOC o reputación revisada si aplica.

## Decisión

- [ ] True Positive, False Positive o Benign True Positive.
- [ ] Acciones realizadas documentadas.
- [ ] Recomendaciones incluidas.
- [ ] Evidencias suficientes para auditoría.

> [!TIP]
> Si no puedes explicar el cierre en tres frases claras, probablemente falta contexto.

Relacionado: [[plantilla-analisis-alerta]], [[plantilla-cierre-falso-positivo]], [[ejemplos-practicos-xql]].

