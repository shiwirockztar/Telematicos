#!/bin/bash

# Variables
INTERFAZ="enp0s3"
IP="192.168.1.50/24"
GATEWAY="192.168.1.1"
DNS1="8.8.8.8"
DNS2="1.1.1.1"

# Activar interfaz
ip link set $INTERFAZ up

# Asignar IP
ip addr flush dev $INTERFAZ
ip addr add $IP dev $INTERFAZ

# Configurar gateway
ip route add default via $GATEWAY

# Configurar DNS
echo "nameserver $DNS1" > /etc/resolv.conf
echo "nameserver $DNS2" >> /etc/resolv.conf

echo "Configuración de red aplicada correctamente"
