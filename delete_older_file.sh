#!/bin/bash

# Ruta de la carpeta
carpeta="/media/mmcblk0p1/csv-data"

# Establecer el valor predeterminado de max_archivos
max_archivos=16

# Comprobar si se proporciona un valor personalizado para max_archivos
if [ $# -eq 1 ]; then
    max_archivos=$1
fi

# Contar la cantidad de archivos en la carpeta
cantidad_archivos=$(find "$carpeta" -maxdepth 1 -type f | wc -l)

# Comprobar si la cantidad de archivos es mayor al valor de max_archivos
echo "Cantidad de archivos: $cantidad_archivos" 
echo "Máximo de archivos: $max_archivos"

if [[ $cantidad_archivos -gt $max_archivos ]]; then
    # Encontrar el archivo más antiguo en la carpeta y eliminarlo
    archivo_mas_antiguo=$(ls -t1 "$carpeta" | tail -1)
    rm "$carpeta/$archivo_mas_antiguo"
    echo "Se ha eliminado el archivo más antiguo: $archivo_mas_antiguo"
else
    echo "No es necesario eliminar archivos. Hay $cantidad_archivos archivos en la carpeta."
fi