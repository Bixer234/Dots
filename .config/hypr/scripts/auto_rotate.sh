#!/bin/bash

# --- 1. Toggle Logic ---
# Check if the rotation listener is already running
if pgrep -f "monitor-sensor" > /dev/null; then
    # If it is, KILL it but DO NOT reset the screen
    pkill -f "monitor-sensor"
    
    # Notify that rotation is now locked
    notify-send -r 101 -i screen-rotation "Rotation" "Auto-Rotate: OFF (Orientation Locked)"
    exit 0
fi

# --- 2. Rotation Daemon Logic ---
MONITOR="eDP-1"
LAST_ORIENTATION=""

notify-send -r 101 -i screen-rotation "Rotation" "Auto-Rotate: ON"

# Start the listener loop
monitor-sensor | while read -r line; do
    if [[ "$line" == *"Accelerometer orientation changed:"* ]]; then
        # Extract and clean the new orientation string
        NEW_ORIENTATION=$(echo "$line" | awk -F': ' '{print $2}' | xargs)

        # Only send a command if the hardware actually moved to a new state
        if [ "$NEW_ORIENTATION" != "$LAST_ORIENTATION" ]; then
            case "$NEW_ORIENTATION" in
                "normal")
                    hyprctl keyword monitor "$MONITOR, preferred, auto, 1, transform, 0"
                    ;;
                "bottom-up")
                    hyprctl keyword monitor "$MONITOR, preferred, auto, 1, transform, 2"
                    ;;
                "right-up")
                    # Fixed horizontal inversion (3 instead of 1)
                    hyprctl keyword monitor "$MONITOR, preferred, auto, 1, transform, 3"
                    ;;
                "left-up")
                    # Fixed horizontal inversion (1 instead of 3)
                    hyprctl keyword monitor "$MONITOR, preferred, auto, 1, transform, 1"
                    ;;
            esac
            LAST_ORIENTATION="$NEW_ORIENTATION"
        fi
    fi
done
