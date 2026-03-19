#!/bin/bash

# Script para medir tasa de transferencia con ping
# Uso: sudo ./Script_R.sh

if [[ $EUID -ne 0 ]]; then
    echo "Error: Ejecutar con sudo"
    exit 1
fi

echo "=== MEDIDOR DE VELOCIDAD (ping) ==="
echo ""

read -p "Servidor (ej: 8.8.8.8): " SERVIDOR
read -p "Paquetes a enviar (ej: 10): " NUM_PAQUETES
read -p "Tamaño paquete en bytes (ej: 56): " TAMANIO

# Valores por defecto
SERVIDOR=${SERVIDOR:-8.8.8.8}
NUM_PAQUETES=${NUM_PAQUETES:-10}
TAMANIO=${TAMANIO:-56}

echo ""
echo "Enviando paquetes a $SERVIDOR..."
echo ""

# Ejecutar ping
RESULTADO=$(ping -c $NUM_PAQUETES -s $TAMANIO "$SERVIDOR" 2>&1)

if [ $? -ne 0 ]; then
    echo "Error: No se puede alcanzar $SERVIDOR"
    exit 1
fi

# Extraer valores
STATS=$(echo "$RESULTADO" | grep "min/avg/max")
MIN=$(echo "$STATS" | awk -F'/' '{print $1}' | awk '{print $NF}')
AVG=$(echo "$STATS" | awk -F'/' '{print $2}')
MAX=$(echo "$STATS" | awk -F'/' '{print $3}')
LOSS=$(echo "$RESULTADO" | grep "packet loss" | awk '{print $6}' | cut -d'%' -f1)

# Calcular velocidad
BYTES_TOTALES=$((NUM_PAQUETES * TAMANIO))
TIEMPO_MS=$(echo "scale=2; $NUM_PAQUETES * $AVG" | bc)
KB_S=$(echo "scale=2; ($BYTES_TOTALES / 1024) / ($TIEMPO_MS / 1000)" | bc)
MBPS=$(echo "scale=2; $KB_S / 1024 * 8" | bc)

# Mostrar resultados
echo "╔═══════════════════════════════════════╗"
echo "║         RESULTADOS                   ║"
echo "╚═══════════════════════════════════════╝"
echo ""
echo "Latencia mín/prom/máx: $MIN / $AVG / $MAX ms"
echo "Pérdida de paquetes:   $LOSS %"
echo "Velocidad:             $KB_S KB/s"
echo "Velocidad estimada:    $MBPS Mbps"
echo ""



