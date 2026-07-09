# Obsidian vault config

Esta carpeta versiona solo configuración portable y segura para un repositorio público.

## Versionado

Se versiona:

- `app.json`
- `appearance.json`
- `community-plugins.json`
- `core-plugins.json`
- `core-plugins-migration.json`
- `graph.json`
- `hotkeys.json`
- `README.md`
- `plugins/*/manifest.json`
- `plugins/*/data.json`
- `themes/*/manifest.json`

Se ignora:

- `workspace` y `workspace.json`, porque guardan estado local de ventanas, pestañas y rutas.
- Código descargado de plugins (`main.js`, `styles.css`) y temas (`theme.css`).
- Iconos descargados por plugins.
- Archivos accidentales `Sin título*` o `Untitled*`.

## Restaurar en otro equipo

1. Clonar el repositorio.
2. Abrir la raíz del repo como vault en Obsidian.
3. Instalar manualmente los community plugins listados en `community-plugins.json`.
4. Instalar el tema configurado en `appearance.json` si se quiere el mismo aspecto.

> [!WARNING]
> No guardar tokens, API keys, webhooks, credenciales ni secretos dentro de `.obsidian`.

