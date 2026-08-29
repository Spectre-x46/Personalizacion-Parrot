# Personalizacion-Parrot — SPECTRE (BSPWM + Polybar)

Mi personalización completa de Parrot OS (escritorio + shell + editor), lista
para restaurar en una máquina nueva **con un solo comando**.

> **¿Todavía no tienes Parrot instalado en el disco?**
> Primero instálalo. Guía paso a paso (pendrive, arranque, elegir el disco
> correcto): **[INSTALL_PARROT.md](INSTALL_PARROT.md)**.

---

## Instalación (sobre un Parrot ya instalado)

**Requisitos:** Parrot ya instalado y arrancado, con `git` y `sudo`.

```sh
git clone https://github.com/Spectre-x46/Personalizacion-Parrot.git
cd Personalizacion-Parrot
chmod +x install.sh
./install.sh                    # perfil victus (HP Victus / NVIDIA) — por defecto
# ./install.sh --profile vmware # replicar la config de la VM
```

El script instala programas + fuentes, deja toda la configuración puesta,
registra la sesión bspwm en el login y cambia tu shell a zsh.
**Nunca hace `apt upgrade`** (que rompe Parrot); solo instalaciones puntuales.

Al terminar: **reinicia**. Entrarás directo a **bspwm** (la sesión queda
preseleccionada; si no, elígela en el menú de LightDM).

---

## ⚠️ Solo en el HP Victus: 3 pasos a mano (necesitan el hardware)

El `install.sh` deja el 90%; esto se cierra en el primer arranque real
(detalle en **[CAJAS.md](CAJAS.md)**):

1. **Driver NVIDIA:** `sudo apt install nvidia-driver` (paquete puntual, NO upgrade).
2. **Refresh del panel:** corre `xrandr` para ver tu salida (ej. `eDP-1`) y los Hz;
   edita la línea de `~/.config/bspwm/machine.sh` con `--rate 144` (o los reales).
3. **Batería / brillo** en la polybar:
   - `ls /sys/class/power_supply/` → ajusta `battery=` / `adapter=` en `polybar/hack/modules.ini`
   - `ls /sys/class/backlight/` → ajusta `card =` del módulo backlight

---

## Qué hay aquí

| Ruta | Qué es |
|---|---|
| **`common/`** | Caja 1: todo lo **portable** (rice + shell + nvim + wallpaper) |
| **`profiles/`** | Caja 2: lo **específico de máquina** (`vmware` / `victus`) |
| **`install.sh`** | El instalador de un solo comando |
| **`packages.txt`** | Lista de programas y de dónde sale cada uno |
| **`CAJAS.md`** | Qué archivo va en qué caja y qué se ajusta a mano |
| **`INSTALL_PARROT.md`** | Cómo instalar Parrot en el SSD desde cero |

## Componentes

BSPWM · sxhkd · Polybar (tema *hack*) · picom v12 · kitty · rofi ·
Neovim (NvChad v2.5) · zsh + powerlevel10k · Hack/Iosevka Nerd Font.

## Nota

El `install.sh` está verificado de sintaxis pero aún **no ejecutado en un Parrot
limpio**. En el primer uso real puede pedir un ajuste menor (nombre de paquete
según la versión de Parrot, o la URL de nvim si cambia la versión).
