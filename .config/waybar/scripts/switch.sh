#!/bin/bash

# --- Configuration ---
THEME_DIR="$HOME/.config/waybar/themes"
MAP_FILE="/tmp/waybar_theme_map.txt"
STATE_FILE="$HOME/.cache/waybar_current_theme"

> "$MAP_FILE"

get_themes() {
    find "$THEME_DIR" -maxdepth 1 -type f -name "*.jsonc" | while read -r conf_file; do
        filename=$(basename "$conf_file")
        theme_name="${filename%.*}"

        style_file="$THEME_DIR/$theme_name.css"

        [[ ! -f "$style_file" ]] && style_file="$HOME/.config/waybar/style.css"

        # Store: Name | ConfPath | StylePath
        echo "$theme_name|$conf_file|$style_file" >> "$MAP_FILE"
        
        echo -e "󱓟 ${theme_name^}"
    done
}

choice=$(get_themes | rofi -dmenu \
    -p "Select Layout" \
    -theme ~/.config/rofi/launchers/type-1/style-3.rasi \
    -theme-str 'element { padding: 10px; } listview { lines: 6; }' \
    -i)

[[ -z "$choice" ]] && exit 0

choice_name=$(echo "$choice" | sed 's/^[^ ]* //')
choice_lower=$(echo "$choice_name" | tr '[:upper:]' '[:lower:]')

SELECTED_CONF=$(grep -i "^$choice_lower|" "$MAP_FILE" | cut -d'|' -f2)
SELECTED_STYLE=$(grep -i "^$choice_lower|" "$MAP_FILE" | cut -d'|' -f3)

if [[ -n "$SELECTED_CONF" && -f "$SELECTED_CONF" ]]; then
    echo "$SELECTED_CONF|$SELECTED_STYLE" > "$STATE_FILE"
    pkill waybar
    while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done
    setsid waybar -c "$SELECTED_CONF" -s "$SELECTED_STYLE" >/dev/null 2>&1 &
    notify-send -t 2000 "Waybar" "Switched to $choice_name"
else
    notify-send "Error" "JSONC config not found for $choice_name"
fi

