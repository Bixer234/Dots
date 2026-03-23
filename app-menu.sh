#!/usr/bin/env bash

# Define the paths to your existing scripts
WALLPAPER_SCRIPT="$HOME/select-wall.sh"
# Updated to point directly to switch.sh
WAYBAR_SCRIPT="$HOME/.config/waybar/scripts/switch.sh"

# Options list
# 󰸉 = Wallpaper icon
#  = Waybar/Settings icon
options="󰸉 Wallpaper\n Waybar Layout"

# Launch Rofi
chosen="$(echo -e "$options" | rofi -dmenu \
    -i \
    -p "Appearance" \
    -theme "$HOME/.config/rofi/launchers/type-1/style-3.rasi")"

# Logic for selection
case "$chosen" in
    "󰸉 Wallpaper")
        bash "$WALLPAPER_SCRIPT"
        ;;
    " Waybar Layout")
        # Matches the icon  used in the options variable above
        bash "$WAYBAR_SCRIPT"
        ;;
    *)
        exit 0
        ;;
esac
