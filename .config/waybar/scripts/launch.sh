#!/bin/bash

# --- Configuration ---
STATE_FILE="$HOME/.cache/waybar_current_theme"

# 1. Determine which Waybar theme was last equipped
if [[ -f "$STATE_FILE" ]]; then
    # Extract the saved paths
    CURRENT_CONF=$(cut -d'|' -f1 "$STATE_FILE")
    CURRENT_STYLE=$(cut -d'|' -f2 "$STATE_FILE")
else
    # Fallback if no state exists
    CURRENT_CONF="$HOME/.config/waybar/themes/default.jsonc"
    CURRENT_STYLE="$HOME/.config/waybar/themes/default.css"
fi

# 2. Kill all instances of Waybar
# -9 (SIGKILL) is effective, but -q (quiet) keeps the terminal clean
killall -q -9 waybar

# 3. Give the system a split second to release the resources
while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done

# 4. Restart with the "equipped" configuration
# setsid & disown ensure it stays alive if you close the terminal
setsid waybar -c "$CURRENT_CONF" -s "$CURRENT_STYLE" >/dev/null 2>&1 &

notify-send -t 1000 "Waybar" "Refreshed current layout"
