# Personalizacion-Parrot — SPECTRE (BSPWM + Polybar)

Mi personalización completa de Parrot OS, lista para restaurar en una máquina
nueva **con un solo comando**.

## Instalación rápida (Parrot recién instalado)

```sh
git clone https://github.com/Spectre-x46/Personalizacion-Parrot.git
cd Personalizacion-Parrot
chmod +x install.sh
./install.sh                    # HP Victus / NVIDIA (por defecto)
# ./install.sh --profile vmware # replicar la VM actual
```

El script instala programas, fuentes y deja toda la configuración puesta.
**Nunca hace `apt upgrade`** (que rompe Parrot); solo instalaciones puntuales.

## Qué hay aquí

- **`common/`** → Caja 1: todo lo portable (rice + shell + nvim + wallpaper).
- **`profiles/`** → Caja 2: lo específico de cada máquina (`vmware` / `victus`).
- **`install.sh`** → el instalador de un solo comando.
- **`packages.txt`** → lista de programas y de dónde sale cada uno.
- **`CAJAS.md`** → qué archivo va en qué caja y qué se ajusta a mano.

## Componentes

BSPWM · sxhkd · Polybar (tema *hack*) · picom v12 · kitty · rofi ·
Neovim (NvChad v2.5) · zsh + powerlevel10k · Hack/Iosevka Nerd Font.
