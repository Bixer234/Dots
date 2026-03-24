#!/bin/bash

# --- Configuration ---
STATE_FILE="$HOME/.cache/waybar_current_theme"

if [[ -f "$STATE_FILE" ]]; then
    CURRENT_CONF=$(cut -d'|' -f1 "$STATE_FILE")
    CURRENT_STYLE=$(cut -d'|' -f2 "$STATE_FILE")
else
    CURRENT_CONF="$HOME/.config/waybar/themes/default.jsonc"
    CURRENT_STYLE="$HOME/.config/waybar/themes/default.css"
fi

killall -q -9 waybar

while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done
setsid waybar -c "$CURRENT_CONF" -s "$CURRENT_STYLE" >/dev/null 2>&1 &

notify-send -t 1000 "Waybar" "Refreshed current layout"
