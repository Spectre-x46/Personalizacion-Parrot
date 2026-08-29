#!/usr/bin/env bash
# =============================================================================
#  SPECTRE dotfiles - Instalador para Parrot OS (BSPWM + Polybar)
#  Deja un Parrot recien instalado identico a tu setup, con UN comando.
#
#  Uso:
#     ./install.sh                 # perfil por defecto: victus (HP Victus / NVIDIA)
#     ./install.sh --profile vmware
#
#  REGLA DE ORO (por Parrot): este script SOLO hace 'apt update' (refresca la
#  lista, es seguro) e 'apt install' de paquetes PUNTUALES. NUNCA hace
#  'apt upgrade' / 'full-upgrade' / 'dist-upgrade', que es lo que rompe Parrot.
# =============================================================================
set -uo pipefail

# ---------------------------------------------------------------- ajustes base
PROFILE="victus"
[ "${1:-}" = "--profile" ] && [ -n "${2:-}" ] && PROFILE="$2"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CFG="$HOME/.config"
STAMP="$(date +%Y%m%d-%H%M%S)"
mkdir -p "$HOME/.local/bin" "$CFG"

case "$PROFILE" in
  victus|vmware) ;;
  *) echo "Perfil desconocido: $PROFILE (usa victus o vmware)"; exit 1 ;;
esac

say(){ printf '\n\033[1;36m==>\033[0m \033[1m%s\033[0m\n' "$*"; }
ok(){  printf '   \033[1;32mok\033[0m %s\n' "$*"; }
warn(){ printf '   \033[1;33m!!\033[0m %s\n' "$*"; }
have(){ command -v "$1" >/dev/null 2>&1; }

say "Instalando perfil: $PROFILE   (repo: $REPO_DIR)"

# ---------------------------------------------------------- 1) paquetes (apt)
say "1/9  Paquetes base (apt install puntual, SIN upgrade)"
sudo apt update            # <-- solo refresca listas; NO actualiza el sistema
APT_PKGS="git curl wget unzip zsh feh rofi bat lsd fontconfig xdotool \
  zsh-autosuggestions zsh-syntax-highlighting \
  build-essential meson ninja-build cmake pkg-config \
  libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev \
  libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev \
  libxcb-shape0-dev libxcb-shm0-dev libxcb-sync-dev libxcb-util-dev \
  libxcb-xfixes0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-keysyms1-dev \
  libxcb-xinerama0-dev libx11-xcb-dev libxext-dev \
  libpixman-1-dev libdbus-1-dev libconfig-dev libgl-dev libegl-dev libepoxy-dev \
  libpcre2-dev libev-dev uthash-dev"
# shellcheck disable=SC2086
sudo apt install -y $APT_PKGS || warn "Algun paquete no se instalo; revisa la salida de arriba."

# bat: en Debian el binario a veces se llama 'batcat'. Creamos alias real 'bat'.
if ! have bat && have batcat; then ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"; ok "symlink bat -> batcat"; fi

# ---------------------------------------------------- 2) compilar bspwm + sxhkd
say "2/9  bspwm + sxhkd (compilar, para clavar tu version)"
build_git(){ # $1 repo  $2 tag  $3 nombre
  local d="/tmp/build-$3-$STAMP"
  git clone --depth=1 --branch "$2" "$1" "$d" 2>/dev/null || git clone --depth=1 "$1" "$d"
  make -C "$d" -j"$(nproc)" && sudo make -C "$d" install && ok "$3 instalado"
}
have bspwm || build_git https://github.com/baskerville/bspwm 0.9.12 bspwm
have sxhkd || build_git https://github.com/baskerville/sxhkd 0.6.3 sxhkd

# --------------------------------------------------------- 3) compilar picom v12
say "3/9  picom v12 (compilar - decidido: Opcion A)"
if ! have picom || ! picom --version 2>/dev/null | grep -q 'v1[2-9]'; then
  d="/tmp/build-picom-$STAMP"
  git clone --depth=1 https://github.com/yshui/picom "$d"
  ( cd "$d" && meson setup --buildtype=release build && ninja -C build && sudo ninja -C build install ) \
    && ok "picom v12 instalado" || warn "Fallo la compilacion de picom (revisa dependencias)."
else ok "picom moderno ya presente"; fi

# ----------------------------------------------------------------- 4) kitty
say "4/9  kitty (instalador oficial)"
if ! have kitty && [ ! -x "$HOME/.local/kitty.app/bin/kitty" ]; then
  curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin || warn "Fallo instalador de kitty"
fi
[ -x "$HOME/.local/kitty.app/bin/kitty" ] && { ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"; \
  ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"; ok "kitty enlazado"; }

# ----------------------------------------------------------------- 5) neovim
say "5/9  neovim 0.11.x (release oficial)"
if ! have nvim || ! nvim --version 2>/dev/null | grep -q 'v0\.1[1-9]'; then
  t="/tmp/nvim-$STAMP.tar.gz"
  curl -fL -o "$t" https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.tar.gz \
    && sudo rm -rf /opt/nvim && sudo tar -C /opt -xzf "$t" \
    && sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && ok "nvim instalado" \
    || warn "Fallo la descarga de nvim (revisa la URL/version)."
else ok "nvim moderno ya presente"; fi

# ------------------------------------------------------------- 6) Nerd Fonts
say "6/9  Fuentes Nerd (Hack + Iosevka) - sin esto se ven cuadritos"
mkdir -p "$HOME/.local/share/fonts"
for F in Hack Iosevka; do
  if ! fc-list | grep -qi "$F Nerd Font"; then
    z="/tmp/$F-$STAMP.zip"
    curl -fL -o "$z" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$F.zip" \
      && unzip -oq "$z" -d "$HOME/.local/share/fonts/$F-NF" && ok "fuente $F" || warn "Fallo fuente $F"
  else ok "fuente $F ya presente"; fi
done
fc-cache -f >/dev/null 2>&1

# ------------------------------------------------------ 7) extras de shell
say "7/9  powerlevel10k (prompt)"
[ -d "$HOME/powerlevel10k" ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
ok "powerlevel10k listo"

# --------------------------------------------------- 8) Caja 1 (dotfiles)
say "8/9  Copiando tu personalizacion (Caja 1)"
backup(){ [ -e "$1" ] && mv "$1" "$1.bak-$STAMP" && warn "respaldado $1 -> $1.bak-$STAMP"; }
place_dir(){ backup "$CFG/$1"; cp -r "$REPO_DIR/common/$2" "$CFG/$1"; ok "~/.config/$1"; }

place_dir bspwm   bspwm
place_dir sxhkd   sxhkd
place_dir polybar polybar
place_dir kitty   kitty
place_dir rofi    rofi
place_dir nvim    nvim
place_dir bin     config-bin
mkdir -p "$CFG/wallpapers"; cp "$REPO_DIR/common/wallpapers/"* "$CFG/wallpapers/"; ok "wallpaper"
chmod +x "$CFG/bspwm/bspwmrc" "$CFG/bspwm/scripts/"* "$CFG/polybar/launch.sh" \
         "$CFG/polybar/hack/scripts/"*.sh 2>/dev/null
# zsh
backup "$HOME/.zshrc";  cp "$REPO_DIR/common/zsh/zshrc"  "$HOME/.zshrc"
backup "$HOME/.p10k.zsh"; cp "$REPO_DIR/common/zsh/p10k.zsh" "$HOME/.p10k.zsh"
ok ".zshrc + .p10k.zsh"

# --------------------------------------------- 9) Perfil de maquina (Caja 2)
say "9/9  Aplicando perfil de maquina: $PROFILE"
mkdir -p "$CFG/picom"
cp "$REPO_DIR/profiles/$PROFILE/picom.conf" "$CFG/picom/picom.conf"
cp "$REPO_DIR/profiles/$PROFILE/machine.sh" "$CFG/bspwm/machine.sh"
chmod +x "$CFG/bspwm/machine.sh"
ok "picom.conf ($PROFILE) + machine.sh"

# ------------------------------------- sesion de login (LightDM/GDM/SDDM)
say "Registrando la sesion bspwm en el login manager"
# Al compilar bspwm desde fuente NO se instala este .desktop (solo lo pone apt).
# Sin el, bspwm no aparece como sesion para elegir y te quedas fuera del escritorio.
if [ ! -f /usr/share/xsessions/bspwm.desktop ]; then
  sudo tee /usr/share/xsessions/bspwm.desktop >/dev/null <<'DESK'
[Desktop Entry]
Name=bspwm
Comment=Binary space partitioning window manager
Exec=bspwm
Type=Application
DesktopNames=bspwm
DESK
  ok "creado /usr/share/xsessions/bspwm.desktop"
else ok "bspwm.desktop ya existe"; fi
# Preseleccionar bspwm para tu usuario (LightDM lee ~/.dmrc)
if ! grep -q '^Session=bspwm' "$HOME/.dmrc" 2>/dev/null; then
  printf '[Desktop]\nSession=bspwm\n' > "$HOME/.dmrc"; ok "~/.dmrc -> Session=bspwm"
else ok "~/.dmrc ya apunta a bspwm"; fi

# shell por defecto -> zsh
if [ "${SHELL:-}" != "$(command -v zsh)" ]; then chsh -s "$(command -v zsh)" 2>/dev/null && ok "shell -> zsh" || warn "No pude cambiar el shell (hazlo con: chsh -s \$(which zsh))"; fi

# plugins de nvim (primer sync en segundo plano/headless)
say "Sincronizando plugins de nvim (puede tardar)"
nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 || warn "El sync de nvim se completara solo en el primer arranque real."

# ------------------------------------------------------------------ final
cat <<EOF

  =====================================================================
   LISTO. Reinicia: entraras directo a bspwm (sesion ya preseleccionada).
   Si el login no te deja, elige "bspwm" en el menu de sesion de LightDM.
  =====================================================================
EOF
if [ "$PROFILE" = "victus" ]; then
cat <<EOF
  FALTA a mano en la Victus (necesita el hardware presente):
    1) Driver NVIDIA:  sudo apt install nvidia-driver   (paquete puntual, NO upgrade)
    2) Bateria/brillo en la polybar (ver CAJAS.md):
         ls /sys/class/power_supply/   -> ajusta battery=/adapter= en polybar/hack/modules.ini
         ls /sys/class/backlight/      -> ajusta 'card =' del modulo backlight
    (El refresh se ajusta solo al nativo del panel: 60 Hz en el Victus basico.)
  =====================================================================
EOF
fi
