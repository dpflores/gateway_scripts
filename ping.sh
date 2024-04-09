#!/bin/bash

# Verifica si se han proporcionado la cantidad correcta de argumentos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <servidor> <intervalo_en_segundos>"
    exit 1
fi

server="$1"
interval="$2"

# Verifica si el intervalo es un número válido
if ! [[ "$interval" =~ ^[0-9]+$ ]]; then
    echo "El intervalo debe ser un número entero válido."
    exit 1
fi

# Bucle infinito que ejecuta el ping cada intervalo de tiempo
while true; do
    ping -c 1 $server > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -n "connected"
    fi
    sleep "$interval"
done
