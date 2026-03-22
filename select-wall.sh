#!/bin/bash

# --- Configuration ---
WALLPAPER_DIR="$HOME/wallpapers"
MONITOR="eDP-1"
TRANSITIONS=("wipe" "grow")
ANGLES=(30 210)
MAP_FILE="/tmp/wallpaper_map.txt"

# Clear the map file
> "$MAP_FILE"

# --- Functions ---
get_wallpapers() {
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) -print0 | while IFS= read -r -d '' file; do
        filename=$(basename "$file")
        display_name="${filename%.*}"
        echo "$display_name|$file" >> "$MAP_FILE"

        if [[ "$filename" =~ \.(mp4|mkv|webm)$ ]]; then
            echo -en "$display_name\0icon\x1fthumbnail://${file}\n"
        else
            echo -en "$display_name\0icon\x1f${file}\n"
        fi
    done
}

# --- Main Logic ---
choice=$(get_wallpapers | rofi -dmenu \
    -p "Wallpapers" \
    -theme-str 'element { orientation: vertical; text-align: center; } element-icon { size: 120px; } listview { columns: 3; lines: 3; }' \
    -i)

[[ -z "$choice" ]] && exit 0

WALLPAPER_PATH=$(grep "^$choice|" "$MAP_FILE" | cut -d'|' -f2)
EXTENSION="${WALLPAPER_PATH##*.}"

if [[ ! -f "$WALLPAPER_PATH" ]]; then
    notify-send "Error" "Could not find file for: $choice"
    exit 1
fi

# 2. Apply Wallpaper
if [[ "$EXTENSION" =~ ^(mp4|mkv|webm)$ ]]; then
    pkill swww-daemon
    pkill mpvpaper
    mpvpaper -o "loop --hwdec=auto" "$MONITOR" "$WALLPAPER_PATH" &
else
    pkill mpvpaper
    if ! pgrep -x "swww-daemon" > /dev/null; then
        swww-daemon & 
        sleep 0.5
    fi

    T_TYPE=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}
    T_ANGLE=${ANGLES[$RANDOM % ${#ANGLES[@]}]}

    swww img "$WALLPAPER_PATH" \
        --outputs "$MONITOR" \
        --transition-type "$T_TYPE" \
        --transition-angle "$T_ANGLE" \
        --transition-duration 1.4 \
        --transition-fps 60 \
        --transition-step 90
fi

# 3. Global UI Theming (Matugen & Pywal)
if [[ ! "$EXTENSION" =~ ^(mp4|mkv|webm)$ ]]; then
    if command -v matugen > /dev/null; then
        # Dominant color extraction to skip interactive prompts
        COLOR_SEED=$(magick "$WALLPAPER_PATH" -resize 1x1 txt:- | grep -oE '#[0-9a-fA-F]{6}' | head -n 1)
        matugen color hex "$COLOR_SEED" -m dark -t scheme-content
    fi
    # -n prevents Pywal from automatically restarting Waybar
    wal -n -q -i "$WALLPAPER_PATH"
else
    # Fallback for video wallpapers
    if command -v matugen > /dev/null; then
        matugen color hex "#3584e4" -m dark -t scheme-content
    fi
    wal -n -q -i "$HOME/wallpapers/default_fallback.png"
fi

# --- 4. Refresh Components ---

# 1. Determine which Waybar theme to reload
STATE_FILE="$HOME/.cache/waybar_current_theme"
if [[ -f "$STATE_FILE" ]]; then
    # Read the saved paths from the Switcher
    CURRENT_CONF=$(cut -d'|' -f1 "$STATE_FILE")
    CURRENT_STYLE=$(cut -d'|' -f2 "$STATE_FILE")
else
    # Fallback if the switcher hasn't been used yet
    CURRENT_CONF="$HOME/.config/waybar/themes/default.jsonc"
    CURRENT_STYLE="$HOME/.config/waybar/themes/default.css"
fi

# 2. Kill Waybar immediately
pkill waybar
while pgrep -u $USER -x waybar >/dev/null; do sleep 0.1; done

# 3. Run background updates (Pywalfox, SwayNC, etc.)
[[ -x $(command -v pywalfox) ]] && pywalfox update &

if pgrep -x "swaync" > /dev/null; then
    swaync-client -R
    swaync-client -rs
fi

# 4. Restart Waybar with the NEW colors but the SAME layout
setsid waybar -c "$CURRENT_CONF" -s "$CURRENT_STYLE" >/dev/null 2>&1 &

# 5. Final Notification
notify-send -t 2000 "Theme Synced" "Colors updated for: $choice"

exit 0
