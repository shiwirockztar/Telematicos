#!/bin/bash

# Script simple para configurar red con iproute2
# Uso: sudo ./Script_R.sh

# $EUID  -> Efectivo ID de usuario (0 para root) ne -> not equal
if [[ $EUID -ne 0 ]]; then
    echo " ⚠ Error: Ejecutar con sudo"
    exit 1
fi

