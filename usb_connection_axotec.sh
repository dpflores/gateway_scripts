#!/bin/bash

# Verificar que se proporcionen las rutas como argumentos
if [ $# -ne 2 ]; then
    echo "Uso: $0 <directorio_USB> <carpeta_origen> [uso_led_externo]"
    exit 1
fi

# Asignar las rutas proporcionadas a variables
USB_MOUNT_DIR="$1"
CARPETA_ORIGEN="$2"
USO_LED_EXTERNO=${3:-false}  # Por defecto, no se utiliza el LED externo

# Encender luz roja y apagar verde
echo 1 > /dev/usrled3  # Rojo
echo 0 > /dev/usrled2  # Verde

# Montar dispositivo USB
sleep 2
sudo mkdir -p "$USB_MOUNT_DIR"
sudo mount /dev/sda1 "$USB_MOUNT_DIR"

# Verificar montaje
if mountpoint -q "$USB_MOUNT_DIR"; then
    echo "Dispositivo USB montado correctamente."
    
    # Copiar carpeta al USB
    sudo cp -r "$CARPETA_ORIGEN" "$USB_MOUNT_DIR"/
    
    echo "Carpeta copiada al dispositivo USB."
    
    # Desmontar USB
    sudo umount "$USB_MOUNT_DIR"
    
    # Verificar desmontaje
    if [ $? -eq 0 ]; then
        echo "Dispositivo USB desmontado correctamente."
        # Encender LED verde
        if [ "$USO_LED_EXTERNO" == true ]; then
            echo 1 > /dev/diod2  # LED externo verde
            echo 0 > /dev/diod3  # LED externo rojo
        else
            echo 1 > /dev/usrled2  # LED interno verde
            echo 0 > /dev/usrled3  # LED interno rojo
        fi
    else
        echo "Error al desmontar dispositivo USB. Encendiendo LED rojo."
        # Encender LED rojo
        if [ "$USO_LED_EXTERNO" == true ]; then
            echo 0 > /dev/diod2  # LED externo verde
            echo 1 > /dev/diod3  # LED externo rojo
        else
            echo 1 > /dev/usrled3  # LED interno rojo
            echo 0 > /dev/usrled2  # LED interno verde
        fi
    fi
else
    echo "Error al montar dispositivo USB. Parpadeando LED rojo durante 3 segundos."
    
    # Parpadear LED rojo durante 3 segundos
    for i in {1..6}; do
        if [ "$USO_LED_EXTERNO" == true ]; then
            echo 1 > /dev/diod3  # LED externo rojo
        else
            echo 1 > /dev/usrled3  # LED interno rojo
        fi
        sleep 0.5
        if [ "$USO_LED_EXTERNO" == true ]; then
            echo 0 > /dev/diod3
        else
            echo 0 > /dev/usrled3
        fi
        sleep 0.5
    done

    echo "Finalizando proceso."
    exit 1
fi

echo "Proceso finalizado."