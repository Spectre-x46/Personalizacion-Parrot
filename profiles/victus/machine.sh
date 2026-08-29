#!/bin/sh
# ===== Perfil de maquina: HP Victus (Intel + RTX 3060) =====
# Lo copia install.sh a ~/.config/bspwm/machine.sh cuando el perfil es "victus".
# NADA de VMware aqui (ni vmware-user-suid-wrapper ni randr-watcher).

# 1) Fix de TEARING en NVIDIA (requiere el driver propietario ya instalado).
#    Si el panel lo maneja la Intel (hibrido/Optimus), esta linea no estorba.
if command -v nvidia-settings >/dev/null 2>&1; then
    nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }" >/dev/null 2>&1 &
fi

# 2) Resolucion + refresh NATIVO del panel (auto-detectado).
#    'xrandr --auto' elige el modo preferido del panel a su refresh nativo.
#    En tu Victus basico eso es 60 Hz (panel estandar). En uno de alta tasa
#    daria 120/144/165 solo. No hay numeros que poner a mano.
xrandr --auto
#    Si algun dia un panel NO llegara solo a su maximo, forzalo a mano:
#      xrandr --output eDP-1 --rate <Hz>     (corre 'xrandr' para ver salida y Hz)
