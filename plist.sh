#!/bin/bash

# Función para verificar permisos de almacenamiento
check_storage_permissions() {
    if [ ! -d "storage" ]; then
        echo "No se encontraron permisos de almacenamiento. Ejecutando termux-setup-storage..."
        termux-setup-storage
        # Esperar hasta que se otorguen los permisos
        while [ ! -d "storage" ]; do
            echo "Esperando permisos de almacenamiento..."
            sleep 2
        done
        echo "Permisos de almacenamiento otorgados."
    else
        echo "Permisos de almacenamiento ya otorgados."
    fi
}

# Verificar y otorgar permisos de almacenamiento si es necesario
check_storage_permissions

# Instalar paquetes necesarios
echo "Instalando paquetes necesarios..."
pkg install -y git python-pip ffmpeg

# Clonar el repositorio
echo "Clonando el repositorio..."
git clone https://www.github.com/robertkirkman/music-pack-generator-coop.git

# Cambiar al directorio del repositorio
cd music-pack-generator-coop

# Instalar dependencias de Python
echo "Instalando dependencias de Python..."
pip install -r requirements.txt

# Crear el directorio necesario
echo "Creando directorio necesario para mods..."
mkdir -p storage/emulated/0/com.owokitty.sm64excoop/user/mods

# Ejecutar el generador de música
echo "Ejecutando el generador de música..."
./music-pack-generator.py https://www.youtube.com/playlist?list=PLp_G0HWfCo5raQSCb_BxY6oA1OVnNBolc --interactive

echo "Script completado exitosamente."