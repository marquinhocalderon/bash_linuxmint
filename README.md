# 🐧 Instaladores Linux Mint – Acer Nitro

Este repositorio (o carpeta) contiene mis scripts personalizados para configurar aplicaciones esenciales en mi laptop **Acer Nitro** con **Linux Mint**. Está pensado para facilitar la instalación rápida, limpia y libre de Snap, respetando la filosofía de Mint. Si usas Linux Mint en cualquier equipo, también puedes aprovecharlo 💻✅

---

## 🛠️ ¿Qué contiene?

- ✅ Instalador manual de **Postman** (sin Snap, sin Flatpak), aca tendre algunos mas ejecutables como instalaciones para linux mint
- ✅ Script con limpieza automática y acceso al menú
- ❌ Snap completamente deshabilitado
- 📂 Organización clara por scripts

---

## 📦 Requisitos previos

Antes de ejecutar los scripts, asegúrate de tener:
- Linux Mint 21.x o superior
- Acceso de administrador (`sudo`)
- Conexión a internet
- Carpeta `Descargas` disponible

---

## 🚀 Instalador de Postman

Script: `instalar-postman.sh`

### 🔧 ¿Qué hace?

1. Descarga la última versión de Postman desde el sitio oficial
2. Descomprime y mueve a `/opt/postman`
3. Crea un acceso directo a `/usr/bin/postman`
4. Agrega Postman al menú de Mint (ícono incluido)
5. Recarga el sistema de aplicaciones para que aparezca de inmediato

### ▶️ Cómo usarlo

```bash
chmod +x instalar-postman.sh
./instalar-postman.sh
