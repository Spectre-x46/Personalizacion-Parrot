#!/bin/bash
# Detecta la interfaz de red activa automaticamente (la de la ruta por defecto).
# Asi funciona igual en VMware (ens33), en el laptop (wlan0/wlp*) o donde sea.
iface=$(ip route show default 2>/dev/null | awk '/default/ {print $5; exit}')
ip_addr=""
[ -n "$iface" ] && ip_addr=$(ip -4 addr show "$iface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ -n "$ip_addr" ]; then
    echo "%{F#2495e7}󰈀%{F-} $ip_addr"
else
    echo "%{F#888888}󰈀%{F-} Desconectado"
fi
