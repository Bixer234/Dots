#!/bin/bash

# --- 1. Toggle Logic ---
if pgrep -f "monitor-sensor" > /dev/null; then
    pkill -f "monitor-sensor"
    notify-send -r 101 -i screen-rotation "Rotation" "Auto-Rotate: OFF (Locked)"
    exit 0
fi

# --- 2. Configuration ---
MONITOR="eDP-1"
TOUCH_DEVICE="wacom-hid-481c-finger"
LAST_ORIENTATION=""

notify-send -r 101 -i screen-rotation "Rotation" "Auto-Rotate: ON"

# --- 3. Rotation Daemon Logic ---
monitor-sensor | while read -r line; do
    if [[ "$line" == *"Accelerometer orientation changed:"* ]]; then
        NEW_ORIENTATION=$(echo "$line" | awk -F': ' '{print $2}' | xargs)

        if [ "$NEW_ORIENTATION" != "$LAST_ORIENTATION" ]; then
            case "$NEW_ORIENTATION" in
                "normal")
                    TRANS=0
                    ;;
                "bottom-up")
                    TRANS=2
                    ;;
                "right-up")
                    # Swapped for your horizontal inversion fix
                    TRANS=3 
                    ;;
                "left-up")
                    # Swapped for your horizontal inversion fix
                    TRANS=1
                    ;;
            esac
            
            # 1. Rotate the monitor
            hyprctl keyword monitor "$MONITOR, preferred, auto, 1, transform, $TRANS"
            
            # 2. Sync the touch device to the monitor (Crucial for Wacom)
            hyprctl keyword "device[$TOUCH_DEVICE]:output" "$MONITOR"
            
            # 3. Apply the transform to the touch device using correct syntax
            hyprctl keyword "device[$TOUCH_DEVICE]:transform" "$TRANS"

            LAST_ORIENTATION="$NEW_ORIENTATION"
        fi
    fi
done
