# ttyd Only Installer

Instala solo una terminal web `ttyd` directa en una URL publica.

## Que instala

- Descarga `ttyd` estatico desde GitHub.
- Instala el binario como `/usr/local/bin/ttyd-static`.
- Habilita modulos Apache:
  - `proxy`
  - `proxy_http`
  - `proxy_wstunnel`
  - `rewrite`
- Configura Apache para publicar `/ttyd/`.
- Activa soporte de colores tipo Ubuntu en la terminal (`TERM=xterm-256color`, `COLORTERM=truecolor` y prompt con color para el usuario real).
- Crea el servicio systemd `ttyd-direct.service`.
- Pide usuario y password durante la instalacion.
- Ejecuta el shell como `bywarrior:bywarrior` por defecto, no como `root`.

## Ruta

- Terminal directa: `https://lobosolitario.tk/ttyd/`

La terminal pide Basic Auth con el usuario y password que indiques al ejecutar el instalador.

## Uso

```bash
sudo ./install.sh
```

Durante la instalacion pregunta:

- Usuario de login de ttyd.
- Password de login de ttyd.
- Confirmacion del password.

## Variables opcionales

```bash
sudo DOMAIN=midominio.com TTYD_PATH=/terminal TTYD_PORT=7681 ./install.sh
```

Variables principales:

- `DOMAIN`: dominio mostrado al final de la instalacion. Default: `lobosolitario.tk`
- `TTYD_PATH`: ruta publica. Default: `/ttyd`
- `TTYD_PORT`: puerto local del backend ttyd. Default: `7681`
- `TTYD_RUN_USER`: usuario real que ejecuta ttyd y el shell. Default: `bywarrior`
- `TTYD_RUN_GROUP`: grupo real que ejecuta ttyd y el shell. Default: igual a `TTYD_RUN_USER`
- `TTYD_HOME`: home del usuario real. Default: `/home/${TTYD_RUN_USER}`
- `TTYD_CWD`: carpeta inicial de la terminal. Default: igual a `TTYD_HOME`
- `TTYD_SHELL`: shell que abre ttyd. Default: `/bin/bash`
- `TTYD_FONT_SIZE`: tamano de letra de ttyd. Default: `16`
- `TTYD_TERM`: valor `TERM` para ttyd. Default: `xterm-256color`
- `TTYD_COLORTERM`: valor `COLORTERM` para ttyd. Default: `truecolor`
- `SERVICE_NAME`: nombre del servicio systemd. Default: `ttyd-direct`

## Notas

Este instalador requiere Apache y systemd. Debe ejecutarse con `sudo`. El servicio queda habilitado con `systemctl enable --now`, por lo que vuelve a iniciar despues de reiniciar el sistema.
