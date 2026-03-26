#!/usr/bin/env bash

WALLPAPER_SCRIPT="$HOME/select-wall.sh"
WAYBAR_SCRIPT="$HOME/.config/waybar/scripts/switch.sh"
options="󰸉  Wallpaper\n  Waybar Layout"

# Launch Rofi
chosen="$(echo -e "$options" | rofi -dmenu \
    -i \
    -p "Appearance" \
    -theme "$HOME/.config/rofi/launchers/type-1/style-3.rasi")"

# Logic for selection
case "$chosen" in
    "󰸉  Wallpaper")
        bash "$WALLPAPER_SCRIPT"
        ;;
    "  Waybar Layout")
        bash "$WAYBAR_SCRIPT"
        ;;
    *)
        exit 0
        ;;
esac
