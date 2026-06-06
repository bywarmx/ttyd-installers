#!/usr/bin/env bash
set -euo pipefail

DOMAIN="${DOMAIN:-lobosolitario.tk}"
TTYD_VERSION="${TTYD_VERSION:-1.7.7}"
TTYD_URL="${TTYD_URL:-https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/ttyd.x86_64}"
TTYD_BIN="${TTYD_BIN:-/usr/local/bin/ttyd-static}"
TTYD_PORT="${TTYD_PORT:-7681}"
TTYD_PATH="${TTYD_PATH:-/ttyd}"
TTYD_RUN_USER="${TTYD_RUN_USER:-bywarrior}"
TTYD_RUN_GROUP="${TTYD_RUN_GROUP:-${TTYD_RUN_USER}}"
TTYD_HOME="${TTYD_HOME:-/home/${TTYD_RUN_USER}}"
TTYD_CWD="${TTYD_CWD:-${TTYD_HOME}}"
TTYD_SHELL="${TTYD_SHELL:-/bin/bash}"
TTYD_FONT_SIZE="${TTYD_FONT_SIZE:-16}"
TTYD_TERM="${TTYD_TERM:-xterm-256color}"
TTYD_COLORTERM="${TTYD_COLORTERM:-truecolor}"
SERVICE_NAME="${SERVICE_NAME:-ttyd-direct}"

if [[ $EUID -ne 0 ]]; then
  echo "Ejecuta con sudo: sudo $0"
  exit 1
fi

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Falta comando requerido: $1"
    exit 1
  }
}

need_cmd curl
need_cmd apache2ctl
need_cmd systemctl
need_cmd sed
need_cmd id
need_cmd getent

enable_user_terminal_colors() {
  local bashrc="${TTYD_HOME}/.bashrc"
  [[ -f "$bashrc" ]] || return 0

  cp -n "$bashrc" "${bashrc}.bak-ttyd-colors" 2>/dev/null || true

  if grep -q '^#force_color_prompt=yes' "$bashrc"; then
    sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' "$bashrc"
  elif ! grep -q '^force_color_prompt=yes' "$bashrc"; then
    printf '\nforce_color_prompt=yes\n' >>"$bashrc"
  fi

  if grep -q '^#export GCC_COLORS=' "$bashrc"; then
    sed -i 's/^#export GCC_COLORS=/export GCC_COLORS=/' "$bashrc"
  elif ! grep -q '^export GCC_COLORS=' "$bashrc"; then
    printf "export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'\n" >>"$bashrc"
  fi
}

if ! id "$TTYD_RUN_USER" >/dev/null 2>&1; then
  echo "No existe el usuario real para ttyd: ${TTYD_RUN_USER}"
  exit 1
fi

if ! getent group "$TTYD_RUN_GROUP" >/dev/null 2>&1; then
  echo "No existe el grupo real para ttyd: ${TTYD_RUN_GROUP}"
  exit 1
fi

read -r -p "Usuario para login de ttyd [bywarrior]: " TTYD_USER
TTYD_USER="${TTYD_USER:-bywarrior}"

while true; do
  read -r -s -p "Password para login de ttyd: " TTYD_PASSWORD
  echo
  read -r -s -p "Repite password: " TTYD_PASSWORD_CONFIRM
  echo
  if [[ -n "$TTYD_PASSWORD" && "$TTYD_PASSWORD" == "$TTYD_PASSWORD_CONFIRM" ]]; then
    break
  fi
  echo "Las contrasenas no coinciden o estan vacias. Intenta otra vez."
done

mkdir -p "$TTYD_CWD"
chown "${TTYD_RUN_USER}:${TTYD_RUN_GROUP}" "$TTYD_CWD"

tmp_ttyd="$(mktemp)"
curl -L -o "$tmp_ttyd" "$TTYD_URL"
install -m 0755 "$tmp_ttyd" "$TTYD_BIN"
rm -f "$tmp_ttyd"

a2enmod proxy proxy_http proxy_wstunnel rewrite >/dev/null
enable_user_terminal_colors

cat >/etc/apache2/conf-available/ttyd-direct.conf <<EOF
ProxyPreserveHost On
ProxyRequests Off

ProxyPass "${TTYD_PATH}/ws" "ws://127.0.0.1:${TTYD_PORT}${TTYD_PATH}/ws"
ProxyPassReverse "${TTYD_PATH}/ws" "ws://127.0.0.1:${TTYD_PORT}${TTYD_PATH}/ws"
ProxyPass "${TTYD_PATH}/" "http://127.0.0.1:${TTYD_PORT}${TTYD_PATH}/"
ProxyPassReverse "${TTYD_PATH}/" "http://127.0.0.1:${TTYD_PORT}${TTYD_PATH}/"
EOF
a2enconf ttyd-direct >/dev/null

cat >"/etc/systemd/system/${SERVICE_NAME}.service" <<EOF
[Unit]
Description=ttyd direct terminal for ${DOMAIN}
After=network.target

[Service]
Type=simple
User=${TTYD_RUN_USER}
Group=${TTYD_RUN_GROUP}
Environment=TERM=${TTYD_TERM}
Environment=COLORTERM=${TTYD_COLORTERM}
Environment=HOME=${TTYD_HOME}
Environment=SHELL=${TTYD_SHELL}
WorkingDirectory=${TTYD_CWD}
ExecStart=${TTYD_BIN} -i 127.0.0.1 -p ${TTYD_PORT} -b ${TTYD_PATH} -W -w ${TTYD_CWD} -c ${TTYD_USER}:${TTYD_PASSWORD} -t fontSize=${TTYD_FONT_SIZE} ${TTYD_SHELL}
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now "${SERVICE_NAME}.service"
systemctl restart "${SERVICE_NAME}.service"

apache2ctl configtest
systemctl reload apache2

echo "Instalacion completa."
echo "Terminal: https://${DOMAIN}${TTYD_PATH}/"
echo "Usuario: ${TTYD_USER}"
echo "Shell ejecutado como: ${TTYD_RUN_USER}:${TTYD_RUN_GROUP}"
