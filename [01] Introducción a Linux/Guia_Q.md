# Guía: Configuración de Red con iproute2

## Comandos Principales de iproute2

### 1. Levantar interfaz
```bash
ip link set eth0 up
```
**Qué hace:** Activa/enciende la interfaz de red (si estaba desactivada).

---

### 2. Limpiar dirección IP anterior
```bash
ip addr flush dev eth0
```
**Qué hace:** Elimina todas las direcciones IP asignadas a la interfaz.

---

### 3. Asignar dirección IP + máscara
```bash
ip addr add 192.168.1.100/24 dev eth0
```
**Qué hace:** Asigna la IP `192.168.1.100` con máscara `/24` (255.255.255.0) a la interfaz.

**Nota:** El `/24` es la notación CIDR:
- `/24` = 255.255.255.0
- `/16` = 255.255.0.0  
- `/8` = 255.0.0.0

---

### 4. Ver dirección IP asignada
```bash
ip addr show eth0
```
**Qué hace:** Muestra la configuración IP actual de la interfaz.

---

### 5. Eliminar ruta antigua
```bash
ip route del default
```
**Qué hace:** Elimina la puerta de enlace (gateway) anterior.

---

### 6. Añadir puerta de enlace
```bash
ip route add default via 192.168.1.1
```
**Qué hace:** Asigna `192.168.1.1` como puerta de enlace predeterminada.

---

### 7. Ver rutas actuales
```bash
ip route show
```
**Qué hace:** Muestra todas las rutas configuradas (incluida la puerta de enlace).

---

### 8. Configurar DNS
```bash
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
```
**Qué hace:** Añade servidores DNS al archivo de configuración.

---

### 9. Ver configuración DNS
```bash
cat /etc/resolv.conf
```
**Qué hace:** Muestra los servidores DNS configurados.

---

## Cómo usar el script

### Requisitos
- Ejecutar con `sudo`
- Tener iproute2 instalado

### Ejecución
```bash
sudo ./configurar_red.sh
```

### Ejemplo de entrada
```
Interfaz de red (ej: eth0): eth0
IP/CIDR (ej: 192.168.1.100/24): 192.168.1.50/24
Gateway (ej: 192.168.1.1): 192.168.1.1
DNS 1 (ej: 8.8.8.8): 8.8.8.8
DNS 2 (ej: 8.8.4.4): 1.1.1.1
```

---

## Verificar configuración después

```bash
# Ver IP configurada
ip addr show eth0

# Ver gateway
ip route show

# Ver DNS
cat /etc/resolv.conf

# Probar conectividad
ping -c 3 8.8.8.8
```

---

## Convertir máscara decimal a CIDR

| Máscara | CIDR |
|---------|------|
| 255.255.255.0 | /24 |
| 255.255.255.128 | /25 |
| 255.255.255.192 | /26 |
| 255.255.255.224 | /27 |
| 255.255.255.240 | /28 |
| 255.255.0.0 | /16 |
| 255.0.0.0 | /8 |

---

## Notas importantes

- El script **requiere permisos de root** (sudo)
- Los cambios son **inmediatos** pero **NO persistentes** (se pierden al reiniciar)
- Para hacer cambios permanentes, editar `/etc/network/interfaces` o usar `netplan`
- `iproute2` es el conjunto moderno de herramientas (reemplaza a `ifconfig` y `route`)
