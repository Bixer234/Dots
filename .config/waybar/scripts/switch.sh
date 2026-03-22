#!/bin/bash

# --- Configuration ---
THEME_DIR="$HOME/.config/waybar/themes"
MAP_FILE="/tmp/waybar_theme_map.txt"
STATE_FILE="$HOME/.cache/waybar_current_theme"

# Refresh the map
> "$MAP_FILE"

# --- Functions ---
get_themes() {
    # Find all .jsonc files in the themes folder
    find "$THEME_DIR" -maxdepth 1 -type f -name "*.jsonc" | while read -r conf_file; do
        filename=$(basename "$conf_file")
        theme_name="${filename%.*}"
        
        # Look for a matching .css file
        style_file="$THEME_DIR/$theme_name.css"
        
        # Fallback to main style if theme-specific one is missing
        [[ ! -f "$style_file" ]] && style_file="$HOME/.config/waybar/style.css"

        # Store: Name | ConfPath | StylePath
        echo "$theme_name|$conf_file|$style_file" >> "$MAP_FILE"
        
        # Output for Rofi (Simple list format)
        echo -en "${theme_name^}\0icon\x1fpreferences-desktop-theme\n"
    done
}

# --- Main Logic ---
choice=$(get_themes | rofi -dmenu \
    -p "Select Layout" \
    -theme-str 'element { padding: 10px; } listview { lines: 6; }' \
    -i)

[[ -z "$choice" ]] && exit 0

choice_lower=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

# Extract paths
SELECTED_CONF=$(grep -i "^$choice_lower|" "$MAP_FILE" | cut -d'|' -f2)
SELECTED_STYLE=$(grep -i "^$choice_lower|" "$MAP_FILE" | cut -d'|' -f3)

# --- SAVE STATE ---
# This allows the wallpaper script to know what to reload
echo "$SELECTED_CONF|$SELECTED_STYLE" > "$STATE_FILE"

# 1. Kill old process
pkill waybar
while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done

# 2. Launch
if [[ -f "$SELECTED_CONF" ]]; then
    setsid waybar -c "$SELECTED_CONF" -s "$SELECTED_STYLE" >/dev/null 2>&1 &
    notify-send -t 2000 "Waybar" "Switched to $choice"
else
    notify-send "Error" "JSONC config not found for $choice"
fi
