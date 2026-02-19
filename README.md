# Telematicos - Introducción a Linux y Servicios de Red

Este repositorio contiene notas y comandos esenciales de una introducción a Linux enfocada en servicios telemáticos de redes. La información cubre desde conceptos básicos del sistema operativo hasta configuración avanzada de red y scripting.

## 📚 Tabla de Contenidos

- [Acceso Administrativo](#acceso-administrativo)
- [Gestores de Paquetes](#gestores-de-paquetes)
- [Conceptos Fundamentales de Red](#conceptos-fundamentales-de-red)
- [Herramientas de Red](#herramientas-de-red)
- [Configuración de Red](#configuración-de-red)
- [Diagnóstico y Conectividad](#diagnóstico-y-conectividad)
- [Servicios de Red](#servicios-de-red)
- [Scripting Bash](#scripting-bash)
- [Permisos de Archivos](#permisos-de-archivos)
- [Referencias y Recursos](#referencias-y-recursos)

---

## 🔐 Acceso Administrativo

### Comando sudo
Para ejecutar comandos con privilegios de administrador:

```bash
sudo su
```

**Credenciales del sistema:**
- Usuario: administrador
- Contraseña: `comm18305`

---

## 📦 Gestores de Paquetes

Los gestores de paquetes permiten instalar, actualizar y eliminar software en Linux.

### Gestores según Distribución

| Gestor | Distribución | Comando de ejemplo |
|--------|--------------|-------------------|
| `apt` | Ubuntu/Debian | `sudo apt install <paquete>` |
| `apk` | Alpine Linux | `apk add <paquete>` |
| `rpm` | Red Hat/Fedora/CentOS | `rpm -i <paquete>.rpm` |

### Ejemplos Prácticos

```bash
# Instalar fortune (generador de frases aleatorias)
sudo apt install fortune

# Instalar cowsay (visualizador ASCII de mensajes)
sudo apt install cowsay
```

---

## 🌐 Conceptos Fundamentales de Red

### Parámetros Básicos de Red

Para que un dispositivo funcione correctamente en una red, necesita configurar cuatro parámetros esenciales:

1. **IP (Dirección IP)**: Identificador único del dispositivo en la red
2. **Netmask (Máscara de red)**: Define el rango de la red local
3. **Gateway (Puerta de enlace)**: Router que conecta con otras redes
4. **DNS (Sistema de Nombres de Dominio)**: Traduce nombres de dominio a direcciones IP

### Comandos para Consultar Configuración

```bash
# Dirección IP
ip a

# Máscara de red (Netmask)
ip a

# Dirección MAC
ip a
ip link

# Puerta de enlace (Gateway)
ip route

# Servidores DNS
cat /etc/resolv.conf
```

---

## 🔧 Herramientas de Red

### iproute2 vs net-tools

Linux ha migrado de las herramientas tradicionales (`net-tools`) a `iproute2`:

| Herramienta Antigua | Herramienta Moderna | Descripción |
|---------------------|---------------------|-------------|
| `ifconfig` | `ip a` / `ip addr` | Configuración de interfaces |
| `route` | `ip route` | Tabla de enrutamiento |
| `netstat` | `ss` | Estado de conexiones |

### Nomenclatura de Interfaces de Red

**enp1s0**: Ethernet Network Peripheral 1 Slot 0
- `en`: Ethernet
- `p1`: Peripheral 1
- `s0`: Slot 0

**lo**: Loopback (interfaz de red local `127.0.0.1`)

**ether**: Dirección MAC (Media Access Control)

---

## ⚙️ Configuración de Red

### Ver Información de Red Completa

```bash
ip a
```

**Ejemplo de salida:**

```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever

2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether f4:4d:30:eb:9a:eb brd ff:ff:ff:ff:ff:ff
    inet 172.21.32.170/16
```

### Configuración Manual de Red

```bash
# Agregar dirección IP a una interfaz
ip address add 10.10.30.1/24 dev enp1s0

# Forma abreviada
ip a a 10.10.30.1/24 dev enp1s0

# Eliminar todas las direcciones de una interfaz
ip flush dev enp1s0

# Agregar gateway por defecto
ip route add default via 10.10.30.254

# Cambiar máscara de red
ip flush dev enp1s0
ip a a 10.10.30.1/16 dev enp1s0
```

### Configuración DHCP

```bash
# Liberar dirección DHCP actual
dhclient -r enp1s0

# Obtener nueva dirección DHCP
dhclient enp1s0
```

---

## 🔍 Diagnóstico y Conectividad

### Comando ping

El comando `ping` verifica la conectividad de red usando el protocolo ICMP.

```bash
# Ping a la propia máquina
ping -c 7 -s 1000 172.21.32.170

# Ping a otra máquina en la red
ping -c 7 -s 1000 10.10.30.2

# Ping al PC del profesor Leal
ping -c 7 -s 1000 172.21.38.36

# Ping a Google para verificar conectividad a Internet
ping -c 4 www.google.com
```

**Parámetros:**
- `-c`: Número de paquetes a enviar
- `-s`: Tamaño del paquete en bytes

### Monitoreo de Red con tcpdump

```bash
# Capturar paquetes ICMP (útil para detectar si alguien hace ping)
sudo tcpdump icmp
```

### Ver Conexiones Activas

```bash
# Ver conexiones TCP activas
ss -tan
```

**Parámetros:**
- `-t`: Mostrar sockets TCP
- `-a`: Mostrar todos los sockets
- `-n`: No resolver nombres (mostrar IPs)

---

## 🌍 Servicios de Red

### Servidor HTTP Simple con Python

```bash
# Iniciar servidor HTTP en el puerto 80
python3 -m http.server 80
```

### Conexiones TCP con netcat (nc)

Netcat es una herramienta para crear conexiones TCP/UDP (nota: no soporta múltiples conexiones simultáneas).

```bash
# Cliente: Conectar al servidor
nc 10.10.30.2 1234

# Servidor: Escuchar en el puerto 1234
nc -l 1234
```

### Servicio de Prueba (Python Flask)

```
http://172.21.38.36
```

---

## 📝 Scripting Bash

### Crear un Script Básico

```bash
# Crear archivo de script
nano test.lab
```

**Contenido del script:**

```bash
#!/bin/bash
echo "hoy es" 
date 
echo "tu fortuna dice"
fortune | cowsay
echo "ve con DIOS"
```

### Dar Permisos de Ejecución

```bash
# Ver permisos actuales
ls -al

# Cambiar permisos para hacer ejecutable el script
chmod 755 test.lab

# Ejecutar el script
./test.lab
```

### Script de Monitoreo de Red

```bash
#!/bin/bash
echo "NETWORK INFO"
ip a
echo "verificando conectividad"
date
ping -c 4 www.google.com
```

### Script con Registro en Archivo (Log)

```bash
#!/bin/bash
echo "NETWORK INFO"
ip a
echo "verificando conectividad"
date > log.file 
ping -c 4 www.google.com >> log.file
```

**Redirección de salida:**
- `>`: Sobrescribe el archivo
- `>>`: Añade al final del archivo

---

## 🔒 Permisos de Archivos

### Entender los Permisos

Los permisos en Linux se representan en tres grupos:

```
-rw-rw-r--
```

| Posición | Significado | Ejemplo |
|----------|-------------|---------|
| 1 | Tipo (`-` archivo, `d` directorio) | `-` |
| 2-4 | Permisos del propietario | `rw-` (lectura, escritura) |
| 5-7 | Permisos del grupo | `rw-` (lectura, escritura) |
| 8-10 | Permisos de otros | `r--` (solo lectura) |

### Representación Numérica (Octal)

| Permiso | Binario | Octal |
|---------|---------|-------|
| `rwx` | 111 | 7 |
| `rw-` | 110 | 6 |
| `r-x` | 101 | 5 |
| `r--` | 100 | 4 |
| `-wx` | 011 | 3 |
| `-w-` | 010 | 2 |
| `--x` | 001 | 1 |
| `---` | 000 | 0 |

### Cambiar Permisos con chmod

```bash
# Dar permisos de ejecución (755 = rwxr-xr-x)
chmod 755 test.lab

# Permisos comunes:
# 755: Propietario puede todo, otros pueden leer y ejecutar
# 644: Propietario lee/escribe, otros solo leen
# 700: Solo el propietario tiene acceso
```

---

## 🖥️ Sistema de Archivos

### Directorio Raíz

| Sistema Operativo | Directorio Raíz |
|-------------------|-----------------|
| Windows | `C:/` |
| Linux | `/` |

### Comandos para Ver Archivos

```bash
# Ver contenido de archivos
cat archivo.txt      # Muestra todo el archivo
more archivo.txt     # Pagina el contenido (avanza)
less archivo.txt     # Pagina el contenido (avanza y retrocede)
```

---

## 🛠️ Herramientas Adicionales

### tilix
Terminal multiplexor que permite dividir la ventana en múltiples paneles.

```bash
tilix
```

### Comandos Básicos del Sistema

```bash
# Mostrar fecha y hora
date

# Imprimir texto
echo "hola"

# Usar pipes (|) para encadenar comandos
date | cowsay
```

---

## 📖 Referencias y Recursos

### Comandos Esenciales Resumen

| Comando | Descripción |
|---------|-------------|
| `ip a` | Ver configuración de red |
| `ip route` | Ver tabla de enrutamiento |
| `ping` | Verificar conectividad |
| `ss -tan` | Ver conexiones TCP activas |
| `tcpdump` | Capturar tráfico de red |
| `nc` | Crear conexiones TCP/UDP |
| `chmod` | Cambiar permisos de archivos |
| `cat /etc/resolv.conf` | Ver servidores DNS |

### Notas Importantes

- Siempre hacer respaldos antes de modificar configuraciones de red
- Los cambios con `ip` son temporales; para hacerlos permanentes, editar `/etc/netplan/` (Ubuntu) o `/etc/network/interfaces` (Debian)
- El protocolo ICMP puede estar bloqueado en algunos firewalls
- Usar `sudo` con precaución para evitar daños al sistema

---

## 📄 Licencia

Este material es para fines educativos como parte del curso de Servicios Telemáticos de Redes.

---


**Última actualización:** Febrero 2026
