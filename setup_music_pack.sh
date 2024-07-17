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

# Función para mostrar el menú y obtener la entrada del usuario
show_menu() {
    echo "Seleccione una opción:"
    echo "1) Ingresar una URL de yt-dlp"
    echo "2) Ingresar un camino local"
    read -p "Opción [1-2]: " choice
    case $choice in
        1)
            read -p "Ingrese la URL de yt-dlp: " url
            command="./music-pack-generator.py \"$url\""
            ;;
        2)
            read -p "Ingrese el camino local: " path
            command="./music-pack-generator.py \"$path\""
            ;;
        *)
            echo "Opción no válida. Saliendo..."
            exit 1
            ;;
    esac

    echo "Seleccione una opción adicional:"
    echo "1) --all"
    echo "2) --interactive"
    echo "3) Ambos"
    echo "4) Ninguno"
    read -p "Opción [1-4]: " option
    case $option in
        1)
            command="$command --all"
            ;;
        2)
            command="$command --interactive"
            ;;
        3)
            command="$command --all --interactive"
            ;;
        4)
            ;;
        *)
            echo "Opción no válida. Saliendo..."
            exit 1
            ;;
    esac
}

# Verificar y otorgar permisos de almacenamiento si es necesario
check_storage_permissions

# Instalar paquetes necesarios si no están instalados
if ! command -v git &> /dev/null; then
    echo "Instalando paquetes necesarios..."
    pkg install -y git python-pip ffmpeg
fi

# Clonar el repositorio si no existe
if [ ! -d "music-pack-generator-coop" ]; then
    echo "Clonando el repositorio..."
    git clone https://www.github.com/robertkirkman/music-pack-generator-coop.git
    cd music-pack-generator-coop
    echo "Instalando dependencias de Python..."
    pip install -r requirements.txt
else
    cd music-pack-generator-coop
fi

# Crear el directorio necesario
echo "Creando directorio necesario para mods..."
mkdir -p /storage/emulated/0/com.owokitty.sm64excoop/user/mods

# Crear un alias para ejecutar el menú del archivo Python
echo "Creando alias para ejecutar el menú del generador de música..."
alias music-gen='cd ~/music-pack-generator-coop && ./music-pack-generator-menu.sh'

# Añadir el alias al archivo .bashrc
if ! grep -q "alias music-gen=" ~/.bashrc; then
    echo 'alias music-gen="cd ~/music-pack-generator-coop && ./music-pack-generator-menu.sh"' >> ~/.bashrc
    source ~/.bashrc
fi

# Crear el archivo de menú del generador de música
cat << 'EOF' > ./music-pack-generator-menu.sh
#!/bin/bash
show_menu() {
    echo "Seleccione una opción:"
    echo "1) Ingresar una URL de yt-dlp"
    echo "2) Ingresar un camino local"
    read -p "Opción [1-2]: " choice
    case $choice in
        1)
            read -p "Ingrese la URL de yt-dlp: " url
            command="./music-pack-generator.py \"$url\""
            ;;
        2)
            read -p "Ingrese el camino local: " path
            command="./music-pack-generator.py \"$path\""
            ;;
        *)
            echo "Opción no válida. Saliendo..."
            exit 1
            ;;
    esac

    echo "Seleccione una opción adicional:"
    echo "1) --all"
    echo "2) --interactive"
    echo "3) Ambos"
    echo "4) Ninguno"
    read -p "Opción [1-4]: " option
    case $option in
        1)
            command="$command --all"
            ;;
        2)
            command="$command --interactive"
            ;;
        3)
            command="$command --all --interactive"
            ;;
        4)
            ;;
        *)
            echo "Opción no válida. Saliendo..."
            exit 1
            ;;
    esac
    echo "Ejecutando el generador de música con los siguientes parámetros:"
    echo $command
    eval $command
}

show_menu
EOF

# Hacer ejecutable el archivo de menú
chmod +x ./music-pack-generator-menu.sh

# Mostrar el menú y obtener la entrada del usuario
show_menu

echo "Script completado exitosamente."
