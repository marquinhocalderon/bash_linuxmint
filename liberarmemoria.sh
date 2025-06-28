#!/bin/bash

# Colores ANSI con más visibilidad
RED='\033[1;31m'     # Rojo claro
GREEN='\033[1;32m'   # Verde claro
BLUE='\033[1;34m'    # Azul claro
YELLOW='\033[1;33m'  # Amarillo claro
NC='\033[0m'         # Sin color

# Verificar si es root
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}🚫 Este script debe ejecutarse como superusuario (root).${NC}"
  echo -e "${YELLOW}💡 Usa: ${BLUE}sudo ./liberar_memoria.sh${NC}"
  exit 1
fi

echo -e "${BLUE}🔄 Sincronizando sistema de archivos...${NC}"
sync

echo -e "${YELLOW}🚮 Liberando caché (PageCache, Dentries e Inodes)...${NC}"
echo 3 > /proc/sys/vm/drop_caches

echo -e "${GREEN}✅ Memoria liberada. Estado actual:${NC}"
free -h
