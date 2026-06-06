# Instaladores de ttyd y Filemanager

Este repositorio contiene scripts de instalación automatizada para configurar y desplegar la terminal web `ttyd` junto a un gestor de archivos PHP en un servidor web Apache bajo systemd.

---

## 📂 Contenido del Repositorio

El proyecto se divide en dos instaladores independientes según tus necesidades:

| Carpeta | Descripción | Componentes Instalados |
| :--- | :--- | :--- |
| **[filemanager-ttyd](./filemanager-ttyd)** | Instala un gestor de archivos web autocontenido (`filemanager.php`) con dos terminales integradas (una directa con login y una embebida mediante iframe). | `filemanager.php`, `ttyd-static`, Módulos Apache, `ttyd-protected.service`, `ttyd-filemanager.service` |
| **[ttyd-only](./ttyd-only)** | Instala únicamente una terminal web directa de acceso seguro protegida por autenticación básica en Apache. | `ttyd-static`, Módulos Apache, `ttyd-direct.service` |

---

## 🛠️ Requisitos Previos

Para ejecutar los scripts correctamente, asegúrate de contar con:
- Un sistema operativo basado en **Linux** (Debian/Ubuntu recomendado).
- Servidor web **Apache** instalado y ejecutándose.
- Administrador de servicios **systemd**.
- Privilegios de administrador (`sudo`).

---

## 🚀 Instrucciones de Uso

### Opción A: Instalar Filemanager + Terminal Integrada
Entra al directorio correspondiente y ejecuta el instalador:
```bash
cd filemanager-ttyd
sudo ./install.sh
```
*También puedes pasar variables de entorno opcionales para personalizar la instalación:*
```bash
sudo DOMAIN=midominio.com TTYD_USER=admin TTYD_PASSWORD=123456 ./install.sh
```
> [!NOTE]  
> Para ver todas las variables de entorno de personalización admitidas, consulta el [README de filemanager-ttyd](./filemanager-ttyd/README.md).

---

### Opción B: Instalar Solo Terminal Web (ttyd)
Entra al directorio correspondiente y ejecuta el instalador:
```bash
cd ttyd-only
sudo ./install.sh
```
*Al ejecutarlo, te solicitará interactivamente el usuario y contraseña para la terminal. También puedes personalizar parámetros mediante variables de entorno:*
```bash
sudo DOMAIN=midominio.com TTYD_PATH=/terminal TTYD_PORT=7681 ./install.sh
```
> [!NOTE]  
> Para ver todas las variables de entorno de personalización admitidas, consulta el [README de ttyd-only](./ttyd-only/README.md).

---

## 📄 Licencia y Notas
Estos scripts están diseñados para automatizar despliegues rápidos y configurar los proxys inversos necesarios en Apache, así como activar el soporte de colores completos (`xterm-256color`) en las terminales web.
