#!/bin/bash
ip_addr=$(ip -4 addr show ens33 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ -n "$ip_addr" ]; then
    echo "%{F#2495e7}󰈀%{F-} $ip_addr"
else
    echo "%{F#888888}󰈀%{F-} Desconectado"
fi

