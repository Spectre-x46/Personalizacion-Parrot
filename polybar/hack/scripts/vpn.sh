#!/bin/bash
vpn_ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ -n "$vpn_ip" ]; then
    echo "%{F#1bbf3e}󰒃%{F-} $vpn_ip"
else
    echo "%{F#888888}󰒃%{F-} Disconnected"
fi
