#!/bin/bash

# Verificar que se proporcionen las rutas como argumentos
if [ $# -ne 2 ]; then
    echo "Uso: $0 <directorio_USB> <carpeta_origen>"
    exit 1
fi

# Asignar las rutas proporcionadas a variables
USB_MOUNT_DIR="$1"
CARPETA_ORIGEN="$2"

# Encender luz roja y apagar verde
echo 1 > /dev/diod3
echo 0 > /dev/diod2

# Montar dispositivo USB
sleep 2
sudo mkdir -p "$USB_MOUNT_DIR"
sudo mount /dev/sda1 "$USB_MOUNT_DIR"

# Verificar montaje
if mountpoint -q "$USB_MOUNT_DIR"; then
    echo "Dispositivo USB montado correctamente."
    
    # Copiar carpeta al USB
    sudo cp -r "$CARPETA_ORIGEN"/* "$USB_MOUNT_DIR"/
    
    echo "Carpeta copiada al dispositivo USB."
    
    # Desmontar USB
    sudo umount "$USB_MOUNT_DIR"
    
    # Verificar desmontaje
    if [ $? -eq 0 ]; then
        echo "Dispositivo USB desmontado correctamente."
        # Encender LED verde
        echo 1 > /dev/diod2
    else
        echo "Error al desmontar dispositivo USB. Encendiendo LED rojo."
        # Encender LED rojo
        echo 1 > /dev/diod3
    fi
else
    echo "Error al montar dispositivo USB. Parpadeando LED rojo durante 3 segundos."
    
    # Parpadear LED rojo durante 3 segundos
    for i in {1..6}; do
        echo 1 > /dev/diod3
        sleep 0.5
        echo 0 > /dev/diod3
        sleep 0.5
    done

    echo "Finalizando proceso."
    exit 1
fi

echo "Proceso finalizado."