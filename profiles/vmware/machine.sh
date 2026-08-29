#!/bin/sh
# ===== Perfil de maquina: VMware =====
# Este archivo lo copia install.sh a ~/.config/bspwm/machine.sh cuando el perfil es "vmware".
# Contiene SOLO lo que tiene sentido dentro de la maquina virtual (Caja 2).

# Integracion con VMware (portapapeles, autofit de resolucion)
vmware-user-suid-wrapper &

# Resolucion: en VMware la ventana cambia de tamano, se deja en automatico
xrandr --auto

# Fix de VMware: recargar bspwm cuando el host cambia el tamano de la ventana
pgrep -f randr-watcher.sh > /dev/null || ~/.config/bspwm/scripts/randr-watcher.sh &
