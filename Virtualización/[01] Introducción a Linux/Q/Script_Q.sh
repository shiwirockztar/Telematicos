#!/bin/bash

# Script simple para configurar red con iproute2
# Uso: sudo ./Script_Q.sh

# $EUID  -> Efectivo ID de usuario (0 para root) ne -> not equal
if [[ $EUID -ne 0 ]]; then
    echo " ⚠ Error: Ejecutar con sudo"
    exit 1
fi

# ============================================
# CONFIGURACIÓN (Valores por defecto)
# ============================================

# Se pueden sobrescribir con Variables

INTERFAZ="enp0s3"
IP="192.168.1.50/24"
GATEWAY="192.168.1.1"
DNS1="8.8.8.8"
DNS2="1.1.1.1"

# Pedir datos
read -p "Interfaz de red (ej: eth0): " INTERFAZ
read -p "IP/CIDR (ej: 192.168.1.100/24): " IP
read -p "Gateway (ej: 192.168.1.1): " GATEWAY
read -p "DNS 1 (ej: 8.8.8.8): " DNS1
read -p "DNS 2 (ej: 8.8.4.4): " DNS2

# ============================================
# CONFIGURACIÓN DE RED
# ============================================

echo "▶ Iniciando configuración..."
echo ""

# 1. Levantar interfaz
ip link set "$INTERFAZ" up
echo "✓ Interfaz levantada"

# 2. Limpiar IP anterior y asignar nueva
ip addr flush dev "$INTERFAZ"
ip addr add "$IP" dev "$INTERFAZ"
echo "✓ IP asignada: $IP"

# 3. Configurar Gateway
ip route del default 2>/dev/null
ip route add default via "$GATEWAY"
echo "✓ Gateway configurado: $GATEWAY"

# 4. Configurar DNS
echo "" > /etc/resolv.conf
echo "nameserver $DNS1" >> /etc/resolv.conf
echo "nameserver $DNS2" >> /etc/resolv.conf
echo "✓ DNS configurado"

# ============================================
# GUARDAR LOG
# ============================================

# Obtener directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/red_$(date +%Y%m%d_%H%M%S).log"

# Guardar configuración en log
cat > "$LOG_FILE" << EOF
CONFIGURACIÓN DE RED - $(date '+%d/%m/%Y %H:%M:%S')
User: $(whoami) | Host: $(hostname)
═════════════════════════════════════════
Interfaz:    $INTERFAZ
IP:          $IP
Gateway:     $GATEWAY
DNS1:        $DNS1
DNS2:        $DNS2
═════════════════════════════════════════
EOF

# ============================================
# MOSTRAR BANNER Y RESUMEN
# ============================================

echo "╔════════════════════════════════════════════╗"
echo "║      CONFIGURACIÓN APLICADA CON ÉXITO      ║"
echo "╚════════════════════════════════════════════╝"
echo ""

echo "═════════════════════════════════════════════"
echo "✓ Script completado exitosamente"
echo "✓ Log guardado en: $LOG_FILE"
echo "═════════════════════════════════════════════"
echo ""
