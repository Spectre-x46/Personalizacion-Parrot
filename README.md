# Personalización Parrot - Spectre_x46

> BSPWM + Polybar setup personalizado con paleta SPECTRE (cyan/azul/púrpura), 
> diseñado para visión accesible y estética cyber moderna.

## 🎨 Características

- **Window Manager**: BSPWM con 9 workspaces nombrados
- **Status Bar**: Polybar tema `hack` adaptado con módulos custom (IP LAN, VPN tun0, Target HTB)
- **Compositor**: Picom con esquinas redondeadas y transparencia (backend xrender, optimizado para VMware)
- **Launcher**: Rofi con tema SPECTRE custom
- **Terminal**: Kitty + Iosevka Nerd Font + banner ASCII
- **Shell**: Zsh + Powerlevel10k

## 🎯 Paleta SPECTRE (daltónico-friendly)

| Estado | Color | Hex |
|---|---|---|
| Activo / Cyan principal | Cyan Neón | `#00ffff` |
| Ocupado / Secundario | Deep Sky Blue | `#00afff` |
| Urgente | Neon Purple | `#af00ff` |
| Inactivo | Dark Gray | `#585858` |

## 📦 Estructura

```
.
├── bspwm/          # Window Manager + scripts (auto-resize VMware)
├── sxhkd/          # Atajos de teclado
├── polybar/hack/   # Status bar tema custom
│   ├── scripts/    # my_ip, vpn, target
│   └── modules.ini # Workspaces SPECTRE
├── picom/          # Compositor (xrender + corners)
├── kitty/          # Terminal config
└── rofi/           # Launcher tema SPECTRE
```

## ⌨️ Atajos clave

- `Super + Enter` → Kitty
- `Super + D` → Rofi (apps)
- `Super + 1-9` → Cambiar workspace
- `Super + Shift + 1-9` → Mover ventana a workspace
- `Super + Q` → Cerrar ventana
- `Super + F5` → Fix layout (resize VMware)

## 🛠️ Dependencias

```
bspwm sxhkd polybar picom rofi kitty 
zsh zsh-autosuggestions zsh-syntax-highlighting
figlet lolcat papirus-icon-theme
```

## 📸 Setup

Wallpaper: SPECTRE_X46  
Banner terminal: NEO (figlet slant + lolcat seed 60)
