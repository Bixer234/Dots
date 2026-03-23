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
        
        # --- ICON CHANGE HERE ---
        # Using the Nerd Font Palette glyph (󱓟) to match image_767dec.png
        echo -e "󱓟 ${theme_name^}"
    done
}

# --- Main Logic ---
choice=$(get_themes | rofi -dmenu \
    -p "Select Layout" \
    -theme ~/.config/rofi/launchers/type-1/style-3.rasi \
    -theme-str 'element { padding: 10px; } listview { lines: 6; }' \
    -i)

[[ -z "$choice" ]] && exit 0

# Fix: Strip the icon and leading space (e.g., "󱓟 Full" becomes "Full")
# Then convert to lowercase to match the filenames in your MAP_FILE
choice_name=$(echo "$choice" | sed 's/^[^ ]* //')
choice_lower=$(echo "$choice_name" | tr '[:upper:]' '[:lower:]')

# Extract paths using the cleaned name
SELECTED_CONF=$(grep -i "^$choice_lower|" "$MAP_FILE" | cut -d'|' -f2)
SELECTED_STYLE=$(grep -i "^$choice_lower|" "$MAP_FILE" | cut -d'|' -f3)

# --- SAVE STATE & LAUNCH ---
if [[ -n "$SELECTED_CONF" && -f "$SELECTED_CONF" ]]; then
    echo "$SELECTED_CONF|$SELECTED_STYLE" > "$STATE_FILE"
    pkill waybar
    while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done
    setsid waybar -c "$SELECTED_CONF" -s "$SELECTED_STYLE" >/dev/null 2>&1 &
    notify-send -t 2000 "Waybar" "Switched to $choice_name"
else
    notify-send "Error" "JSONC config not found for $choice_name"
fi

