#!/bin/bash

# Colores ANSI con más visibilidad
RED='\033[1;31m'     # Rojo claro
GREEN='\033[1;32m'   # Verde claro
BLUE='\033[1;34m'    # Azul claro
YELLOW='\033[1;33m'  # Amarillo claro
NC='\033[0m'         # Sin color

echo -e "${BLUE}🐳 Instalador de Docker para Linux Mint - Estilo Bacán 😎${NC}"

# Paso 1: Eliminar posibles instalaciones antiguas
echo -e "${YELLOW}🧹 Eliminando versiones antiguas de Docker (si existen)...${NC}"
sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null

# Paso 2: Instalar dependencias necesarias
echo -e "${YELLOW}📦 Instalando paquetes requeridos...${NC}"
sudo apt update
sudo apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Paso 3: Agregar la clave GPG oficial de Docker
echo -e "${YELLOW}🔐 Agregando la clave GPG oficial de Docker...${NC}"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Paso 4: Agregar el repositorio oficial de Docker
echo -e "${YELLOW}📥 Agregando el repositorio de Docker...${NC}"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Paso 5: Instalar Docker Engine y Docker Compose
echo -e "${YELLOW}⚙️ Instalando Docker Engine, CLI y Docker Compose Plugin...${NC}"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Paso 6: Habilitar e iniciar el servicio Docker
echo -e "${YELLOW}🛠️ Habilitando y arrancando Docker...${NC}"
sudo systemctl enable docker
sudo systemctl start docker

# Paso 7: Agregar el usuario actual al grupo 'docker'
echo -e "${YELLOW}👤 Agregando tu usuario al grupo 'docker'...${NC}"
sudo usermod -aG docker "$USER"

echo -e "${GREEN}✅ Docker se ha instalado correctamente.${NC}"
echo -e "${BLUE}👉 Ejecuta 'docker run hello-world' para probarlo.${NC}"
echo -e "${YELLOW}🔁 Recuerda cerrar sesión y volver a entrar para usar 'docker' sin sudo.${NC}"
