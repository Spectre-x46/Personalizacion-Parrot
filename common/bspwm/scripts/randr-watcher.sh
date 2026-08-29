#!/bin/bash
# Auto-reload bspwm cuando cambia la resolución (VMware resize fix)
last_geom=""
while true; do
    current_geom=$(xrandr | grep ' connected' | grep -oP '\d+x\d+\+\d+\+\d+' | head -1)
    if [ -n "$current_geom" ] && [ "$current_geom" != "$last_geom" ]; then
        if [ -n "$last_geom" ]; then
            sleep 0.3
            xrandr --auto
            bspc wm -r
        fi
        last_geom="$current_geom"
    fi
    sleep 1
done

