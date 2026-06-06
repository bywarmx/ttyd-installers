# Filemanager + ttyd Installer

Instala un `filemanager.php` autocontenido y dos backends `ttyd` para usar terminal web.

## Que instala

- Crea `/var/www/html/filemanager.php` desde el codigo embebido en `install.sh`.
- Descarga `ttyd` estatico desde GitHub.
- Instala el binario como `/usr/local/bin/ttyd-static`.
- Habilita modulos Apache:
  - `proxy`
  - `proxy_http`
  - `proxy_wstunnel`
  - `rewrite`
- Configura Apache para publicar `/ttyd/`.
- Activa soporte de colores tipo Ubuntu en la terminal (`TERM=xterm-256color`, `COLORTERM=truecolor` y prompt con color para el usuario real).
- Crea servicios systemd:
  - `ttyd-protected.service`: terminal directa con login.
  - `ttyd-filemanager.service`: backend local para el iframe del filemanager, permitido solo si Apache recibe la cookie del filemanager.
- Ejecuta ambos shells como `bywarrior:bywarrior` por defecto, no como `root`.

## Rutas

- Filemanager: `https://lobosolitario.tk/filemanager.php?p=`
- Terminal directa: `https://lobosolitario.tk/ttyd/`

La terminal directa pide login. Desde el filemanager, el boton `Terminal` usa la misma ruta `/ttyd/`, pero el filemanager inserta una cookie interna para no pedir login dentro del iframe.

## Uso

```bash
sudo ./install.sh
```

## Variables opcionales

```bash
sudo DOMAIN=midominio.com TTYD_USER=admin TTYD_PASSWORD=123456 ./install.sh
```

Variables principales:

- `DOMAIN`: dominio mostrado al final de la instalacion. Default: `lobosolitario.tk`
- `DOCROOT`: raiz web. Default: `/var/www/html`
- `TTYD_USER`: usuario de la terminal directa. Default: `bywarrior`
- `TTYD_PASSWORD`: password de la terminal directa. Default: `010286`
- `TTYD_RUN_USER`: usuario real que ejecuta ttyd y el shell. Default: `bywarrior`
- `TTYD_RUN_GROUP`: grupo real que ejecuta ttyd y el shell. Default: igual a `TTYD_RUN_USER`
- `TTYD_HOME`: home del usuario real. Default: `/home/${TTYD_RUN_USER}`
- `TTYD_CWD`: carpeta inicial de la terminal. Default: igual a `TTYD_HOME`
- `TTYD_SHELL`: shell que abre ttyd. Default: `/bin/bash`
- `TTYD_FONT_SIZE`: tamano de letra de la terminal directa. Default: `16`
- `TERMINAL_BYPASS_TOKEN`: token de cookie usado por el filemanager para el iframe.
- `TTYD_FM_FONT_SIZE`: tamano de letra del ttyd embebido. Default: igual a `TTYD_FONT_SIZE`
- `TTYD_TERM`: valor `TERM` para ttyd. Default: `xterm-256color`
- `TTYD_COLORTERM`: valor `COLORTERM` para ttyd. Default: `truecolor`

## Notas

Este instalador requiere Apache y systemd. Debe ejecutarse con `sudo`. Los servicios quedan habilitados con `systemctl enable --now`, por lo que vuelven a iniciar despues de reiniciar el sistema.
