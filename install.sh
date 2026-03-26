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

# --- 3. Bootstrap Setup Tools ---
if ! command -v gum &> /dev/null; then
    echo -e "${YELLOW}Installing 'gum' for an interactive experience...${NC}"
    sudo pacman -S --needed --noconfirm gum git base-devel
fi

gum style --border double --margin "1" --padding "1" --foreground 212 "Bixer's Dotfiles Installer"

# --- 4. Bootstrap Yay ---
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}Installing Yay (AUR Helper)...${NC}"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd - || exit
fi

# --- 5. Install ALL System Packages ---
PKGS=(
    zsh zsh-completions jq gum system-age
    hyprland waybar rofi rofi-emoji swaync kitty fastfetch
    hyprlock hypridle hyprshot polkit-gnome grimblast-git slurp
    swww-git awww mpvpaper matugen-bin adw-gtk-theme nwg-look
    python-pywal16 imagemagick xdg-desktop-portal-hyprland
    squeekboard iio-sensor-proxy iio-hyprland-git 
    pavucontrol blueman brightnessctl preload power-profiles-daemon
    cliphist wl-clipboard wl-clip-persist nwg-clipman gpu-screen-recorder-ui
    tesseract tesseract-data-eng python-pillow python-pytesseract
    yt-dlp gallery-dl python-pipx 
    nautilus gvfs gvfs-mtp gvfs-smb ffmpegthumbnailer
    ttf-google-sans ttf-google-sans-flex ttf-jetbrains-mono-nerd 
    maplemono-ttf maple-mono-nf-cn-unhinted
)

echo -e "${YELLOW}Installing system packages...${NC}"
yay -S --needed --noconfirm "${PKGS[@]}"

# --- 6. Deep Clean .config (Nuclear Option) ---
if gum confirm "This will DELETE existing config folders to replace them. Proceed?"; then
    echo -e "${RED}Cleaning up old config folders...${NC}"
    cd "$HOME/.config" || exit
    TARGETS=(hypr fastfetch kitty gtk-3.0 gtk-4.0 matugen rofi swaync waybar)
    for folder in "${TARGETS[@]}"; do
        rm -rf "$folder"
    done
    echo -e "${BLUE}✔ Configs cleared.${NC}"
fi

# --- 7. Direct Copy Operations ---
echo -e "${YELLOW}Copying Dotfiles to system...${NC}"

# Root Home scripts/folders
cp ~/Dots/appmenu.sh ~
cp ~/Dots/select-wall.sh ~
cp ~/Dots/toggle_squeekboard.sh ~
cp -r ~/Dots/wallpapers ~

# Make scripts executable
chmod +x ~/appmenu.sh ~/select-wall.sh ~/toggle_squeekboard.sh

# Config Folders
cp -r ~/Dots/.config/fastfetch ~/.config/
cp -r ~/Dots/.config/gtk-3.0 ~/.config/
cp -r ~/Dots/.config/gtk-4.0 ~/.config/
cp -r ~/Dots/.config/hypr ~/.config/
cp -r ~/Dots/.config/kitty ~/.config/
cp -r ~/Dots/.config/matugen ~/.config/
cp -r ~/Dots/.config/rofi ~/.config/
cp -r ~/Dots/.config/swaync ~/.config/
cp -r ~/Dots/.config/waybar ~/.config/

echo -e "${GREEN}✔ Files copied successfully!${NC}"

# --- 8. GTK & Theme Selection ---
echo -e "${YELLOW}Setting adw-gtk3-dark as default theme...${NC}"
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# --- 9. Global Theme Integration (Rofi) ---
echo -e "${YELLOW}Finalizing Rofi system paths...${NC}"
sudo mkdir -p /usr/share/rofi/themes
if [ -d "$HOME/.config/rofi/launchers/type-1/shared" ]; then
    sudo cp -r "$HOME/.config/rofi/launchers/type-1/shared" /usr/share/rofi/themes/
    sudo cp "$HOME/.config/rofi/launchers/type-1/style-3.rasi" /usr/share/rofi/themes/
fi

# --- 10. Enable Services & Set Shell ---
sudo systemctl enable --now bluetooth.service iio-sensor-proxy.service preload.service power-profiles-daemon.service
sudo usermod -aG video,input,bluetooth "$USER"
sudo chsh -s $(which zsh) $USER

# --- 11. Pywal Hyprland Template ---
echo -e "${YELLOW}Creating Pywal Hyprland template...${NC}"
mkdir -p "$HOME/.config/wal/templates"
cat <<EOF > "$HOME/.config/wal/templates/colors-hyprland.conf"
\$foreground = rgb({foreground.strip})
\$background = rgb({background.strip})
\$cursor = rgb({cursor.strip})

\$color0 = rgb({color0.strip})
\$color1 = rgb({color1.strip})
\$color2 = rgb({color2.strip})
\$color3 = rgb({color3.strip})
\$color4 = rgb({color4.strip})
\$color5 = rgb({color5.strip})
\$color6 = rgb({color6.strip})
\$color7 = rgb({color7.strip})
\$color8 = rgb({color8.strip})
\$color9 = rgb({color9.strip})
\$color10 = rgb({color10.strip})
\$color11 = rgb({color11.strip})
\$color12 = rgb({color12.strip})
\$color13 = rgb({color13.strip})
\$color14 = rgb({color14.strip})
\$color15 = rgb({color15.strip})
EOF

# --- 12. CSS Path Fixes ---
find "$HOME/.config/waybar" -name "*.css" -exec sed -i 's|~/.cache/wal/|../../../.cache/wal/|g' {} +
[ -f "$HOME/.config/swaync/style.css" ] && sed -i 's|~/.cache/wal/|../../.cache/wal/|g' "$HOME/.config/swaync/style.css"

# --- 13. Initial Theme & Reload ---
if [ -f "$HOME/wallpapers/Sky.jpg" ]; then
    awww img "$HOME/wallpapers/Sky.jpg"
    wal -i "$HOME/wallpapers/Sky.jpg"
fi

hyprctl reload
killall waybar && waybar &

# --- 14. Finish ---
gum style --foreground 212 --border double --margin 1 --padding 1 "Installation Complete!"

if gum confirm "Reboot now?"; then
    reboot
fi
