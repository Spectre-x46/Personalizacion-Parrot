#!/bin/sh
# ===== Perfil de maquina: HP Victus (Intel + RTX 3060) =====
# Lo copia install.sh a ~/.config/bspwm/machine.sh cuando el perfil es "victus".
# NADA de VMware aqui (ni vmware-user-suid-wrapper ni randr-watcher).

# 1) Fix de TEARING en NVIDIA (requiere el driver propietario ya instalado).
#    Si el panel lo maneja la Intel (hibrido/Optimus), esta linea no estorba.
if command -v nvidia-settings >/dev/null 2>&1; then
    nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }" >/dev/null 2>&1 &
fi

# 2) Resolucion + REFRESH del panel.
#    << AJUSTA ESTO EN EL PRIMER ARRANQUE >>
#    Corre  `xrandr`  para ver el nombre de tu salida (ej: eDP-1) y los Hz disponibles,
#    y descomenta/edita la linea de abajo. Los Victus suelen ser 144Hz.
# xrandr --output eDP-1 --mode 1920x1080 --rate 144
xrandr --auto   # provisional hasta confirmar salida y refresh con `xrandr`
