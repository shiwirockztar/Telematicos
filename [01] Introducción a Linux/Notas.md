# Telematicos

sudo su
[sudo] contraseña para administrador: comm18305

//apt gestor de paquetes para la distribucion de linux ubuntu
//apk gestor de paquetes para la distribucion de linux ubuntu
//rpm gestor de paquetes para la distribucion de linux redhub

sudo apt install fortune
sudo apt install cowsay

Ip
Netmask
Gateway
DNS

iproute2 (en vez del viejo Net-tools ifconfig)

enp1s0 = ethernet network peipherical 1 slot 0 

lo = loopback

ether= direccion mac

Ip              ip a
Netmask         ip a
Mac             ip a, ip link
Gateway         ip route
DNS             cat /etc/resolv.conf

//unidad raiz
root windows C:/
root LINUX /

//forma de ver ficheros 
cat more less

ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether f4:4d:30:eb:9a:eb brd ff:ff:ff:ff:ff:ff
    inet 172.21.32.170/16 

    172.21.32.170/16 
//ping a mi pc 
ping -c 7 -s 1000 172.21.32.170

ping -c 7 -s 1000 10.10.30.2

//ping pc del profe Leal
ping -c 7 -s 1000 172.21.38.36

//servicio de parcial (python flash)
http://172.21.38.36

//como nota  para saber si alguien me hace ping
sudo tcpdump icmp

ip address add 10.10.30.1/24 dev enp1s0
ip flush dev enp1s0
ip a aa 10.10.30.1/24 dev enp1s0

//anexar el gateway
ip route add default 10.10.30.254

ss -tan

tilix

//conexion tcp (nc no es multiconexion)
nc 10.10.30.2 1234
nc -l 1234

pytho 3 -m  http.server 80


ip flush dev enp1s0
ip a aa 10.10.30.1/16 dev enp1s0

dhclient - r enp1s0


date 
echo hola 
cowsay | date

//creando un bash
nano test.lab

#!/bin/bash
echo "hoy es" 
date 
echo "tu fortuna dice"
fortune | cowsay
echo "ve con DIOS"

//intentar ejecutar script
./test.lab

// ver permisos
ls -al

-rw-rw-r--
//directorio -
-mis_permisos-mi_grupo-otros--
111 101 101
7 5 5
chmod 755 test.lab


echo NETWORK INFO
ip a
echo "verificando conectividad"
date
ping -c 4 www.google.com

#!/bin/bash
echo NETWORK INFO
ip a
echo "verificando conectividad"
date >log.file 
ping -c 4 www.google.com >> log.file
