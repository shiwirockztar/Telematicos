#!/bin/bash

# ============================================
# Script de Configuración Rápida de Red
# ============================================
# Configura los parámetros de red de forma automatizada
# usando comandos del paquete iproute2
#
# Uso: sudo ./Q.sh
# o:   sudo ./Q.sh [INTERFAZ] [IP/CIDR] [GATEWAY] [DNS1] [DNS2]
#
# Ejemplos:
#   sudo ./Q.sh
#   sudo ./Q.sh enp0s3 192.168.1.50/24 192.168.1.1 8.8.8.8 1.1.1.1
#   sudo ./Q.sh eth0 10.10.30.1/24 10.10.30.254 8.8.8.8 8.8.4.4

# ============================================
# CONFIGURACIÓN (Valores por defecto)
# ============================================

# Se pueden sobrescribir con argumentos
INTERFAZ="${1:-enp0s3}"
IP_COMPLETA="${2:-192.168.1.50/24}"
GATEWAY="${3:-192.168.1.1}"
DNS1="${4:-8.8.8.8}"
DNS2="${5:-1.1.1.1}"

# Separar IP y CIDR de la entrada
IP=$(echo $IP_COMPLETA | cut -d'/' -f1)
CIDR=$(echo $IP_COMPLETA | cut -d'/' -f2)

# Por si solo se proporciona la IP sin CIDR
if [[ -z "$CIDR" ]]; then
    CIDR="24"
    IP_COMPLETA="$IP/24"
fi

# ============================================
# MOSTRAR BANNER
# ============================================

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║  Configuración Automatizada de Red (iproute2)"
echo "╚════════════════════════════════════════════╝"
echo ""
echo "Parámetros a configurar:"
echo "  • Interfaz:  $INTERFAZ"
echo "  • IP/CIDR:   $IP_COMPLETA"
echo "  • Gateway:   $GATEWAY"
echo "  • DNS 1:     $DNS1"
echo "  • DNS 2:     $DNS2"
echo ""

# ============================================
# VERIFICACIÓN DE PERMISOS
# ============================================

if [[ $EUID -ne 0 ]]; then
    echo "❌ Error: Este script debe ejecutarse con permisos de administrador"
    echo "   Uso: sudo ./Q.sh"
    exit 1
fi

# ============================================
# CONFIGURACIÓN DE RED
# ============================================

echo "▶ Iniciando configuración..."
echo ""

# 1. Activar interfaz de red
echo "[1/5] Activando interfaz de red: $INTERFAZ"
if sudo ip link set $INTERFAZ up 2>/dev/null; then
    echo "      ✓ Interfaz activada"
else
    echo "      ⚠ Advertencia: No se pudo activar la interfaz"
fi
echo ""

# 2. Limpiar configuraciones anteriores
echo "[2/5] Limpiando configuración anterior en $INTERFAZ"
if sudo ip addr flush dev $INTERFAZ 2>/dev/null; then
    echo "      ✓ Configuración anterior eliminada"
else
    echo "      ✓ Sin configuración previa"
fi
echo ""

# 3. Asignar dirección IP y máscara
echo "[3/5] Asignando IP: $IP_COMPLETA"
if sudo ip addr add $IP_COMPLETA dev $INTERFAZ 2>/dev/null; then
    echo "      ✓ IP asignada correctamente"
else
    echo "      ❌ Error al asignar IP"
    exit 1
fi
echo ""

# 4. Configurar Gateway (ruta por defecto)
echo "[4/5] Configurando Gateway: $GATEWAY"
if sudo ip route add default via $GATEWAY 2>/dev/null; then
    echo "      ✓ Gateway configurado"
else
    # Si ya existe, intenta eliminarlo y agregarlo de nuevo
    sudo ip route del default via $GATEWAY 2>/dev/null
    if sudo ip route add default via $GATEWAY 2>/dev/null; then
        echo "      ✓ Gateway reconfigurado"
    else
        echo "      ⚠ Advertencia: No se pudo agregar gateway"
    fi
fi
echo ""

# 5. Configurar servidores DNS
echo "[5/5] Configurando DNS"
if sudo bash -c "echo 'nameserver $DNS1' > /etc/resolv.conf" && \
   sudo bash -c "echo 'nameserver $DNS2' >> /etc/resolv.conf"; then
    echo "      ✓ DNS configurado"
else
    echo "      ❌ Error al configurar DNS"
fi
echo ""

# ============================================
# VERIFICACIÓN Y RESUMEN
# ============================================

echo "╔════════════════════════════════════════════╗"
echo "║      CONFIGURACIÓN APLICADA CON ÉXITO     ║"
echo "╚════════════════════════════════════════════╝"
echo ""

echo "📍 Dirección IP Asignada:"
ip addr show $INTERFAZ 2>/dev/null | grep "inet " | awk '{print "   " $2}' || echo "   (No disponible)"
echo ""

echo "🚪 Gateway y Rutas:"
ip route show 2>/dev/null | grep default | awk '{print "   " $0}' || echo "   (No disponible)"
echo ""

echo "🔍 Servidores DNS Configurados:"
sudo cat /etc/resolv.conf 2>/dev/null | grep nameserver | awk '{print "   " $0}' || echo "   (No disponible)"
echo ""

echo "📡 Prueba de Conectividad al Gateway:"
if ping -c 1 -W 2 $GATEWAY > /dev/null 2>&1; then
    echo "   ✓ Gateway alcanzable"
else
    echo "   ⚠ Gateway no responde (podría no estar disponible o bloqueado)"
fi
echo ""

echo "═════════════════════════════════════════════"
echo "✓ Script completado exitosamente"
echo "═════════════════════════════════════════════"
echo ""