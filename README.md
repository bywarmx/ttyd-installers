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

## 🚀 Métodos de Instalación

Puedes realizar la instalación clonando este repositorio o ejecutando directamente el script mediante un comando de una sola línea (`curl`).

### Método A: Clonando el repositorio (Recomendado)

Ideal si deseas conservar los archivos localmente o revisar la estructura de antemano.

```bash
# 1. Clonar el repositorio
git clone https://github.com/bywarmx/ttyd-installers.git

# 2. Navegar a la carpeta del repositorio
cd ttyd-installers
```

* **Para instalar Filemanager + ttyd:**
  ```bash
  cd filemanager-ttyd
  sudo ./install.sh
  ```

* **Para instalar Solo ttyd:**
  ```bash
  cd ttyd-only
  sudo ./install.sh
  ```

---

### Método B: Instalación directa vía `curl` (Sin clonar)

Descarga y ejecuta el instalador que prefieras de forma directa. Al finalizar, el script descargado se puede eliminar de forma segura.

* **Para instalar Filemanager + ttyd:**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/bywarmx/ttyd-installers/main/filemanager-ttyd/install.sh -o install-fm.sh
  chmod +x install-fm.sh
  sudo ./install-fm.sh
  rm install-fm.sh
  ```

* **Para instalar Solo ttyd (te solicitará interactivamente el usuario y contraseña en consola):**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/bywarmx/ttyd-installers/main/ttyd-only/install.sh -o install-ttyd.sh
  chmod +x install-ttyd.sh
  sudo ./install-ttyd.sh
  rm install-ttyd.sh
  ```

---

## ⚙️ Personalización Avanzada

Ambos instaladores admiten variables de entorno opcionales para personalizar rutas, puertos, dominios y credenciales. Por ejemplo:

```bash
# Cambiar dominio y credenciales del filemanager + ttyd
sudo DOMAIN=midominio.com TTYD_USER=admin TTYD_PASSWORD=123456 ./install.sh

# Cambiar puerto y ruta de acceso para ttyd-only
sudo DOMAIN=midominio.com TTYD_PATH=/terminal TTYD_PORT=7681 ./install.sh
```

Para ver la lista completa de variables de entorno disponibles, consulta los README internos:
- [Documentación detallada de filemanager-ttyd](./filemanager-ttyd/README.md)
- [Documentación detallada de ttyd-only](./ttyd-only/README.md)
