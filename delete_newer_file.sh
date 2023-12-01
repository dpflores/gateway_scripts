#!/bin/bash

# Ruta de la carpeta
carpeta="/root/ITEMAQ/ANGULAMIENTO"

archivo_mas_nuevo=$(ls -t1 "$carpeta" | head -1)
rm "$carpeta/$archivo_mas_nuevo"
echo "Se ha eliminado el archivo más nuevo: $archivo_mas_nuevo"
