#!/bin/bash

# Colores ANSI con más visibilidad
RED='\033[1;31m'     # Rojo claro
GREEN='\033[1;32m'   # Verde claro
BLUE='\033[1;34m'    # Azul claro
YELLOW='\033[1;33m'  # Amarillo claro
NC='\033[0m'         # Sin color

# Detectar carpeta de Descargas
if [ -d "$HOME/Descargas" ]; then
  DOWNLOADS="$HOME/Descargas"
elif [ -d "$HOME/Downloads" ]; then
  DOWNLOADS="$HOME/Downloads"
else
  echo -e "${RED}❌ No se encontró la carpeta de Descargas.${NC}"
  exit 1
fi

echo -e "${BLUE}📂 Usando carpeta de descargas: $DOWNLOADS${NC}"

# Paso 1: Ir a la carpeta de Descargas
cd "$DOWNLOADS" || exit

# Paso 2: Descargar la última versión de Postman
echo -e "${YELLOW}📥 Descargando Postman...${NC}"
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz

# Paso 3: Descomprimir
echo -e "${YELLOW}📦 Descomprimiendo...${NC}"
tar -xvzf postman.tar.gz

# Paso 4: Mover a /opt
echo -e "${YELLOW}📁 Instalando en /opt...${NC}"
sudo rm -rf /opt/postman
sudo mv Postman /opt/postman

# Paso 5: Crear acceso directo en /usr/bin
echo -e "${YELLOW}🔗 Creando acceso directo...${NC}"
sudo ln -sf /opt/postman/Postman /usr/bin/postman

# Paso 6: Crear lanzador de escritorio
echo -e "${YELLOW}🧷 Agregando al menú de Mint...${NC}"
cat <<EOF > ~/.local/share/applications/postman.desktop
[Desktop Entry]
Name=Postman
Exec=postman
Icon=/opt/postman/app/resources/app/assets/icon.png
Type=Application
Categories=Development;
EOF

update-desktop-database ~/.local/share/applications

# Paso 7: Hacer el lanzador ejecutable
chmod +x ~/.local/share/applications/postman.desktop

echo -e "${GREEN}✅ ¡Postman instalado correctamente!${NC}"
echo -e "${BLUE}🔍 Puedes buscarlo en el menú o escribir '${YELLOW}postman${BLUE}' en la terminal.${NC}"
