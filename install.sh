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

gum style --border double --margin "1" --padding "1" --foreground 212 "Bixer's Ultimate Hyprland Installer (Stow Edition)"

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
    stow                                  # <--- Essential for symlinking
    zsh zsh-completions hyprland waybar rofi rofi-emoji swaync 
    hyprlock hypridle hyprshot polkit-gnome grimblast-git slurp jq
    swww-git awww mpvpaper matugen-bin adw-gtk-theme nwg-look
    python-pywal16 imagemagick xdg-desktop-portal-hyprland
    squeekboard iio-sensor-proxy iio-hyprland-git 
    pavucontrol blueman brightnessctl preload power-profiles-daemon
    cliphist wl-clipboard wl-clip-persist nwg-clipman gpu-screen-recorder-ui
    tesseract tesseract-data-eng python-pillow python-pytesseract
    yt-dlp gallery-dl python-pipx gum system-age
    nautilus gvfs gvfs-mtp gvfs-smb ffmpegthumbnailer
    ttf-google-sans ttf-google-sans-flex
    ttf-jetbrains-mono-nerd maplemono-ttf maple-mono-nf-cn-unhinted
)

gum spin --spinner dot --title "Installing system packages..." -- yay -S --needed --noconfirm "${PKGS[@]}"

# --- 6. OCR4Linux Installation ---
if gum confirm "Install OCR4Linux?"; then
    gum spin --spinner triangle --title "Cloning and setting up OCR4Linux..." -- bash -c "
        git clone https://github.com/moheladwy/OCR4Linux.git /tmp/OCR4Linux
        cd /tmp/OCR4Linux
        chmod +x setup.sh
        ./setup.sh
    "
    chmod +x "$HOME/.config/OCR4Linux/OCR4Linux.sh"
fi

# --- 7. GNU Stow Symlinking ---
echo -e "${YELLOW}Linking Dotfiles via GNU Stow...${NC}"

# We assume your dotfiles directory is organized by 'package' folders.
# Example: ~/dotfiles/hypr/ contains .config/hypr/land.conf
# Or: ~/dotfiles/zsh/ contains .zshrc

for dir in */; do
    dir=${dir%/} # Remove trailing slash
    
    # Skip non-config folders
    [[ "$dir" == "OCR4Linux" ]] && continue
    [[ "$dir" == "scripts" ]] && continue # Add any other folder to skip here

    echo -e "${BLUE}Stowing $dir...${NC}"
    
    # If a real directory/file exists where we want to link, back it up
    # Stow will fail if a real file is in the way.
    if [ -e "$HOME/.$dir" ] || [ -e "$HOME/.config/$dir" ]; then
        echo -e "${YELLOW}Existing config found for $dir. Moving to backup...${NC}"
        mv "$HOME/.$dir" "$HOME/.${dir}_bak" 2>/dev/null
        mv "$HOME/.config/$dir" "$HOME/.config/${dir}_bak" 2>/dev/null
    fi

    stow -v -R -t "$HOME" "$dir"
done

# --- 8. Global Theme Integration ---
echo -e "${YELLOW}Integrating Rofi themes...${NC}"
sudo mkdir -p /usr/share/rofi/themes
ROFI_THEME="$HOME/.config/rofi/launchers/type-1/style-3.rasi"
if [ -f "$ROFI_THEME" ]; then
    sudo cp "$ROFI_THEME" /usr/share/rofi/themes/
    sudo cp -r "$HOME/.config/rofi/launchers/type-1/shared" /usr/share/rofi/themes/
fi

# --- 9. Default Shell ---
ZSH_PATH=$(which zsh)
if [ "$SHELL" != "$ZSH_PATH" ] && gum confirm "Change default shell to ZSH?"; then
    chsh -s "$ZSH_PATH"
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
sudo systemctl enable --now bluetooth.service iio-sensor-proxy.service preload.service power-profiles-daemon.service
sudo usermod -aG video,input,bluetooth "$USER"

[ -d "$HOME/wallpapers" ] && wal -i "$HOME/wallpapers/" -n -q 2>/dev/null
rm -rf /tmp/yay /tmp/OCR4Linux

# --- 13. Finish ---
gum style --foreground 212 --border double --margin 1 --padding 1 "Installation Complete! Reboot recommended."

if gum confirm "Reboot now?"; then
    reboot
fi
