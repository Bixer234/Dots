#!/bin/bash

# --- 1. Colors & Branding ---
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' 

# --- 2. Root Check ---
if [ "$EUID" -eq 0 ]; then 
  echo -e "${RED}Please do not run this script as root/sudo.${NC}"
  exit 1
fi

DOTFILES_DIR=$(pwd)

# --- 3. Bootstrap Gum ---
if ! command -v gum &> /dev/null; then
    echo -e "${YELLOW}Installing 'gum' for an interactive experience...${NC}"
    sudo pacman -S --needed --noconfirm gum
fi

gum style --border double --margin "1" --padding "1" --foreground 212 "Bixer's Ultimate Hyprland Installer"

# --- 4. Bootstrap Yay ---
if ! command -v yay &> /dev/null; then
    if gum confirm "Yay not found. Install it now?"; then
        sudo pacman -S --needed base-devel git
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay && makepkg -si --noconfirm
        cd "$DOTFILES_DIR"
    else
        echo "Exiting: Yay is required."
        exit 1
    fi
fi

# --- 5. Install Dependencies ---
PKGS=(
    # Shell & Terminal
    zsh zsh-completions
    # Core Desktop & Compositor
    hyprland waybar rofi rofi-emoji swaync 
    hyprlock hypridle hyprshot polkit-gnome
    grimblast-git slurp jq
    # Wallpaper & Theming
    swww-git awww mpvpaper matugen-bin adw-gtk-theme nwg-look
    python-pywal16 imagemagick xdg-desktop-portal-hyprland
    # System & Hardware
    squeekboard iio-sensor-proxy iio-hyprland-git 
    pavucontrol blueman brightnessctl preload power-profiles-daemon
    # Clipboard & Screen Recording
    cliphist wl-clipboard wl-clip-persist nwg-clipman gpu-screen-recorder-ui
    # OCR & Image Processing
    tesseract tesseract-data-eng python-pillow python-pytesseract
    # Media & Downloads
    yt-dlp gallery-dl python-pipx gum system-age
    # File Management
    nautilus gvfs gvfs-mtp gvfs-smb ffmpegthumbnailer
    # Fonts
    ttf-google-sans ttf-google-sans-flex
    ttf-jetbrains-mono-nerd maplemono-ttf maple-mono-nf-cn-unhinted
)

gum spin --spinner dot --title "Installing system packages..." -- yay -S --needed --noconfirm "${PKGS[@]}"

# --- 6. OCR4Linux Installation ---
if gum confirm "Install OCR4Linux (Screen-to-Clipboard OCR)?"; then
    gum spin --spinner triangle --title "Cloning and setting up OCR4Linux..." -- bash -c "
        git clone https://github.com/moheladwy/OCR4Linux.git /tmp/OCR4Linux
        cd /tmp/OCR4Linux
        chmod +x setup.sh
        ./setup.sh
    "
    chmod +x "$HOME/.config/OCR4Linux/OCR4Linux.sh"
    echo -e "${GREEN}✔ OCR4Linux installed and permissions set.${NC}"
fi

# --- 7. Applying Configs ---
echo -e "${YELLOW}Deploying configuration files...${NC}"
mkdir -p "$HOME/.config"

CONFIGS=("hypr" "waybar" "rofi" "squeekboard" "swaync" "hyprlock" "hypridle")

for folder in "${CONFIGS[@]}"; do
    if [ -d "$DOTFILES_DIR/$folder" ]; then
        [ -d "$HOME/.config/$folder" ] && mv "$HOME/.config/$folder" "$HOME/.config/${folder}_bak_$(date +%H%M%S)"
        cp -r "$DOTFILES_DIR/$folder" "$HOME/.config/$folder"
        echo -e "${GREEN}✔ Installed $folder${NC}"
    fi
done

[ -f "$DOTFILES_DIR/.zshrc" ] && cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# --- 8. Global Theme Integration ---
echo -e "${YELLOW}Integrating Rofi themes into system directory...${NC}"
sudo mkdir -p /usr/share/rofi/themes
if [ -f "$HOME/.config/rofi/launchers/type-1/style-3.rasi" ]; then
    sudo cp "$HOME/.config/rofi/launchers/type-1/style-3.rasi" /usr/share/rofi/themes/
    sudo cp -r "$HOME/.config/rofi/launchers/type-1/shared" /usr/share/rofi/themes/
    echo -e "${GREEN}✔ Rofi themes moved to /usr/share/rofi/themes/${NC}"
fi

# --- 9. Changing Default Shell ---
ZSH_PATH=$(which zsh)
if [ "$SHELL" != "$ZSH_PATH" ]; then
    if gum confirm "Change default shell to ZSH?"; then
        chsh -s "$ZSH_PATH"
    fi
fi

# --- 10. Essential Startup Injections ---
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
if [ -f "$HYPR_CONF" ]; then
    echo -e "${YELLOW}Configuring Hyprland Startup Services...${NC}"
    grep -q "polkit-gnome" "$HYPR_CONF" || echo "exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1" >> "$HYPR_CONF"
    grep -q "blueman-applet" "$HYPR_CONF" || echo "exec-once = blueman-applet" >> "$HYPR_CONF"
    grep -q "hypridle" "$HYPR_CONF" || echo "exec-once = hypridle" >> "$HYPR_CONF"
    grep -q "iio-hyprland" "$HYPR_CONF" || echo "exec-once = iio-hyprland" >> "$HYPR_CONF"
fi

# --- 11. Path Fixes ---
gum spin --spinner monkey --title "Patching CSS paths..." -- sleep 1
find "$HOME/.config/waybar/themes" -name "*.css" -exec sed -i 's|~/.cache/wal/|../../../.cache/wal/|g' {} +
find "$HOME/.config/waybar/themes" -name "*.css" -exec sed -i 's|~/.config/waybar/|../|g' {} +
[ -f "$HOME/.config/swaync/style.css" ] && sed -i 's|~/.cache/wal/|../../.cache/wal/|g' "$HOME/.config/swaync/style.css"

# --- 12. Final System Tweaks ---
fc-cache -fv > /dev/null 2>&1

echo -e "${YELLOW}Enabling system services...${NC}"
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now iio-sensor-proxy.service
sudo systemctl enable --now preload.service
sudo systemctl enable --now power-profiles-daemon.service

sudo usermod -aG video,input,bluetooth "$USER"

# Initial Pywal
if [ -d "$HOME/wallpapers" ]; then
    wal -i "$HOME/wallpapers/" -n -q 2>/dev/null
fi

rm -rf /tmp/yay /tmp/OCR4Linux

# --- 13. Finish ---
gum style --foreground 212 --border double --margin 1 --padding 1 "Installation Complete! Reboot recommended."

if gum confirm "Reboot now?"; then
    reboot
fi
