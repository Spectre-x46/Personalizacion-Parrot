# Las dos cajas: qué es portable y qué es específico de la máquina

Toda la personalización está separada en dos grupos para poder llevarla a un
Parrot nuevo **sin arrastrar los parches de VMware**.

---

## 📦 CAJA 1 — "Sirve en cualquier Parrot" (carpeta `common/`)

Esto se restaura **tal cual** en cualquier máquina. Es tu look & feel completo.

| Archivo / carpeta | Qué es |
|---|---|
| `common/bspwm/bspwmrc` | Escritorio: bordes, gaps, reglas. **Ya portable** (lo de la máquina se saca a `machine.sh`) |
| `common/bspwm/scripts/` | `bspwm_resize` y `randr-watcher.sh` (este último solo lo usa el perfil vmware) |
| `common/sxhkd/sxhkdrc` | Tus atajos de teclado |
| `common/polybar/` | La barra completa (tema `hack` activo) con tus colores nuevos |
| `common/polybar/hack/scripts/my_ip.sh` | **Mejorado**: detecta la red sola (ya no depende de `ens33`) |
| `common/kitty/` | Terminal (fuente Hack Nerd Font) |
| `common/rofi/` | Menú de apps (fuente Iosevka Nerd Font) |
| `common/nvim/` | Editor NvChad v2.5 + tus cambios (tema onedark, list=false) |
| `common/config-bin/` | `~/.config/bin` (target del polybar) |
| `common/zsh/zshrc` + `p10k.zsh` | Shell: prompt + alias (`cat=bat`, `ls=lsd`, etc.) |
| `common/wallpapers/Spectre_x46.png` | Fondo de pantalla |

---

## 📦 CAJA 2 — "Específico de la máquina" (carpeta `profiles/`)

Esto **cambia según dónde arranques**. El `install.sh` pone el correcto según
el perfil que elijas (`victus` o `vmware`).

| Archivo | vmware (hoy) | victus (nuevo) |
|---|---|---|
| `profiles/<perfil>/picom.conf` | `xrender`, sin vsync (parche VM) | **`glx` + vsync** (acelerado por la RTX) |
| `profiles/<perfil>/machine.sh` | `vmware-user-suid-wrapper`, `randr-watcher`, `xrandr --auto` | NVIDIA `ForceFullCompositionPipeline` + `xrandr --rate 144` |

### Cosas de la Caja 2 que se ajustan a mano en el primer arranque de la Victus
Estos valores **solo se pueden saber con el hardware real** (por eso no van
fijos en el repo):

- **Refresh del panel** → `xrandr` para ver la salida (ej. `eDP-1`) y los Hz;
  editar `~/.config/bspwm/machine.sh`.
- **Batería** en la polybar → `ls /sys/class/power_supply/` y ajustar
  `battery=` / `adapter=` en `polybar/hack/modules.ini` (hoy `BAT1`/`ACAD`).
- **Brillo** en la polybar → `ls /sys/class/backlight/` y ajustar el `card =`
  del módulo backlight (probable `intel_backlight`).
- **Driver NVIDIA** → `sudo apt install nvidia-driver` (paquete puntual).

---

## Cómo se restaura en el Parrot nuevo

```sh
git clone <este-repo> && cd Personalizacion-Parrot
chmod +x install.sh
./install.sh                 # perfil victus por defecto
# (o ./install.sh --profile vmware  para replicar la VM actual)
```
