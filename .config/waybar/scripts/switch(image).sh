#!/bin/bash

# --- Configuration ---
THEME_DIR="$HOME/.config/waybar/themes"
MAP_FILE="/tmp/waybar_theme_map.txt"
STATE_FILE="$HOME/.cache/waybar_current_theme"  # <--- The State File path

# Refresh the map
> "$MAP_FILE"

# --- Functions ---
get_themes() {
    find "$THEME_DIR" -maxdepth 1 -type f -name "*.jsonc" | while read -r conf_file; do
        filename=$(basename "$conf_file")
        theme_name="${filename%.*}"
        style_file="$THEME_DIR/$theme_name.css"
        preview_img="$THEME_DIR/$theme_name.png" # Added preview logic back in

        [[ ! -f "$style_file" ]] && style_file="$HOME/.config/waybar/style.css"
        [[ ! -f "$preview_img" ]] && preview_img="preferences-desktop-theme"

        echo "$theme_name|$conf_file|$style_file" >> "$MAP_FILE"
        echo -en "${theme_name^}\0icon\x1f${preview_img}\n"
    done
}

# --- Main Logic ---
choice=$(get_themes | rofi -dmenu \
    -p "Select Layout" \
    -theme-str 'element { orientation: vertical; text-align: center; padding: 10px; } element-icon { size: 120px; } listview { columns: 3; lines: 2; }' \
    -i)

[[ -z "$choice" ]] && exit 0

choice_lower=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

# Extract paths
SELECTED_CONF=$(grep -i "^$choice_lower|" "$MAP_FILE" | cut -d'|' -f2)
SELECTED_STYLE=$(grep -i "^$choice_lower|" "$MAP_FILE" | cut -d'|' -f3)

# --- THE ADDED LINE ---
# This saves the current selection so the Wallpaper Script can read it later
echo "$SELECTED_CONF|$SELECTED_STYLE" > "$STATE_FILE"
# ----------------------

# 1. Kill old process
pkill waybar
while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done

# 2. Launch with explicit JSONC config and CSS style
if [[ -f "$SELECTED_CONF" ]]; then
    setsid waybar -c "$SELECTED_CONF" -s "$SELECTED_STYLE" >/dev/null 2>&1 &
    notify-send -t 2000 "Waybar" "Loaded $choice"
else
    notify-send "Error" "JSONC config not found for $choice"
fi
