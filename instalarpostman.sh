#!/bin/bash

# Paso 1: Ir a la carpeta Descargas
cd ~/Descargas || exit

# Paso 2: Descargar la última versión de Postman
echo "Descargando Postman..."
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz

# Paso 3: Descomprimir
echo "Descomprimiendo..."
tar -xvzf postman.tar.gz

# Paso 4: Mover a /opt
echo "Instalando en /opt..."
sudo rm -rf /opt/postman
sudo mv Postman /opt/postman

# Paso 5: Crear acceso directo en /usr/bin
echo "Creando acceso directo..."
sudo ln -sf /opt/postman/Postman /usr/bin/postman

# Paso 6: Crear lanzador de escritorio
echo "Creando ícono en el menú..."
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



echo "✅ ¡Postman instalado correctamente!"
echo "Puedes buscarlo en el menú o escribir 'postman' en la terminal."
