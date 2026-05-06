#!/bin/bash
TARGET_FILE="$HOME/.config/polybar/hack/.target"

if [ -s "$TARGET_FILE" ]; then
    ip_addr=$(awk '{print $1}' "$TARGET_FILE")
    name=$(awk '{print $2}' "$TARGET_FILE")
    if [ -n "$ip_addr" ] && [ -n "$name" ]; then
        echo "%{F#e51d0b}󰓾%{F-} $ip_addr - $name"
    elif [ -n "$ip_addr" ]; then
        echo "%{F#e51d0b}󰓾%{F-} $ip_addr"
    else
        echo "%{F#e51d0b}󰓾%{F-} No Target"
    fi
else
    echo "%{F#e51d0b}󰓾%{F-} No Target"
fi
