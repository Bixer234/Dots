#!/bin/bash

# Function to get status for Waybar
get_status() {
    STATUS=$(gsettings get org.gnome.desktop.a11y.applications screen-keyboard-enabled)
    if [ "$STATUS" = "true" ]; then
        echo '{"text": "", "class": "enabled"}'
    else
        echo '{"text": "", "class": "disabled"}'
    fi
}

# If Waybar asks for status
if [ "$1" = "status" ]; then
    get_status
    exit 0
fi

# Toggle Logic
STATUS=$(gsettings get org.gnome.desktop.a11y.applications screen-keyboard-enabled)

if [ "$STATUS" = "true" ]; then
    gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false
    # Notification for OFF
    notify-send -r 99 -i input-keyboard "Touch Mode" "Virtual Keyboard Disabled"
else
    gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true
    # Notification for ON
    notify-send -r 99 -i input-keyboard "Touch Mode" "Virtual Keyboard Enabled"
fi

# Signal Waybar to update instantly
pkill -RTMIN+1 waybar