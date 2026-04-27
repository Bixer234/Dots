#!/bin/bash

# --- Configuration ---
WALLPAPER_DIR="$HOME/wallpapers"
MONITOR="eDP-1"
TRANSITIONS=("wipe" "grow")
ANGLES=(30 210)

# --- Functions ---
get_wallpapers() {
    find -L "$WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \
           -o -iname "*.gif" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) \
        | sort
}

# --- Main Logic ---
WALLPAPER_PATH=$(get_wallpapers | vicinae dmenu \
    -n "Wallpapers" \
    -p "Search wallpapers..." \
    -s "Available ({count})")

# Exit if no selection was made
[[ -z "$WALLPAPER_PATH" ]] && exit 0

EXTENSION="${WALLPAPER_PATH##*.}"
CHOICE=$(basename "${WALLPAPER_PATH%.*}")

if [[ ! -f "$WALLPAPER_PATH" ]]; then
    notify-send "Error" "Could not find file: $WALLPAPER_PATH"
    exit 1
fi

# --- Application Logic ---
if [[ "$EXTENSION" =~ ^(mp4|mkv|webm)$ ]]; then
    pkill awww-daemon
    pkill mpvpaper
    mpvpaper -o "loop --hwdec=auto" "$MONITOR" "$WALLPAPER_PATH" &
else
    pkill mpvpaper
    if ! pgrep -x "awww-daemon" > /dev/null; then
        awww-daemon &
        sleep 0.5
    fi

    T_TYPE=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}
    T_ANGLE=${ANGLES[$RANDOM % ${#ANGLES[@]}]}

    awww img "$WALLPAPER_PATH" \
        --outputs "$MONITOR" \
        --transition-type "$T_TYPE" \
        --transition-angle "$T_ANGLE" \
        --transition-duration 1.4 \
        --transition-fps 60 \
        --transition-step 90
fi

# --- Color Extraction & Theming ---
if [[ ! "$EXTENSION" =~ ^(mp4|mkv|webm)$ ]]; then
    if command -v matugen > /dev/null; then
        COLOR_SEED=$(magick "$WALLPAPER_PATH" -resize 1x1 txt:- | grep -oE '#[0-9a-fA-F]{6}' | head -n 1)
        matugen color hex "$COLOR_SEED" -m dark -t scheme-content
    fi
    wal -n -q -i "$WALLPAPER_PATH"
else
    if command -v matugen > /dev/null; then
        matugen color hex "#3584e4" -m dark -t scheme-content
    fi
    wal -n -q -i "$HOME/wallpapers/default_fallback.png"
fi

# --- Squeekboard Refresh ---
if pgrep -x "squeekboard" > /dev/null; then
    pkill squeekboard
    squeekboard &
fi

# --- Waybar & UI Refresh ---
STATE_FILE="$HOME/.cache/waybar_current_theme"
if [[ -f "$STATE_FILE" ]]; then
    CURRENT_CONF=$(cut -d'|' -f1 "$STATE_FILE")
    CURRENT_STYLE=$(cut -d'|' -f2 "$STATE_FILE")
else
    CURRENT_CONF="$HOME/.config/waybar/themes/default.jsonc"
    CURRENT_STYLE="$HOME/.config/waybar/themes/default.css"
fi

pkill waybar
while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done

[[ -x $(command -v pywalfox) ]] && pywalfox update &

if pgrep -x "swaync" > /dev/null; then
    swaync-client -R
    swaync-client -rs
fi

setsid waybar -c "$CURRENT_CONF" -s "$CURRENT_STYLE" >/dev/null 2>&1 &

notify-send -t 2000 "Theme Synced" "Colors & UI updated for: $CHOICE"

exit 0
