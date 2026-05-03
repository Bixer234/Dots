#!/bin/bash

# --- Configuration ---
WALLPAPER_DIR="$HOME/wallpapers"
MONITOR="eDP-1"
TRANSITIONS=("wipe" "grow")
ANGLES=(30 210)
MAP_FILE="/tmp/wallpaper_map.txt"

# Clear/Initialize the map file
: > "$MAP_FILE"

# --- Functions ---
get_wallpapers() {
    # Added -L to follow symlinks if WALLPAPER_DIR is a link
    find -L "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) -print0 | while IFS= read -r -d '' file; do
        filename=$(basename "$file")
        display_name="${filename%.*}"
        
        # Store mapping for retrieval later
        echo "$display_name|$file" >> "$MAP_FILE"

        # Rofi formatting with icons
        if [[ "$filename" =~ \.(mp4|mkv|webm)$ ]]; then
            echo -en "$display_name\0icon\x1fthumbnail://${file}\n"
        else
            echo -en "$display_name\0icon\x1f${file}\n"
        fi
    done
}

# --- Main Logic ---
# Pipe the function output into Rofi
choice=$(get_wallpapers | rofi -dmenu \
    -theme ~/.config/rofi/launchers/type-1/style-3.rasi \
    -p "Select Wallpaper" \
    -theme-str '
        inputbar {
            font: "Google Sans Flex 12";
        }
        prompt {
            font: "Google Sans Flex 12";
        }
        entry {
            font: "Google Sans Flex 12";
            placeholder: "Search...";
            placeholder-color: @fg;
        }
        window { 
            width: 800px; 
            height: 474px; 
            border-radius: 20px;
        }
        listview { 
            columns: 2; 
            lines: 1;
            spacing: 1px; 
            cycle: true;
            dynamic: false;
            layout: vertical;
            fixed-columns: true;
        }
        element { 
            orientation: vertical; 
            padding: 2px 12px 12px 12px; 
            border-radius: 20px;
        }
        element-icon { 
            size: 240px; 
            horizontal-align: 0.5;
            vertical-align: 0.5;
            border-radius: 20px;
        }
        element-text { 
            font: "Google Sans Flex 12";
            horizontal-align: 0.5; 
            vertical-align: 0.5; 
            margin: 0px 0px 10px 0px; 
        }
    ' \
    -i)

# Exit if no selection was made (Esc pressed)
[[ -z "$choice" ]] && exit 0

# Retrieve the full path from our map file
WALLPAPER_PATH=$(grep "^$choice|" "$MAP_FILE" | cut -d'|' -f2)
EXTENSION="${WALLPAPER_PATH##*.}"

if [[ ! -f "$WALLPAPER_PATH" ]]; then
    notify-send "Error" "Could not find file for: $choice"
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
        # Use ImageMagick to get a seed color
        COLOR_SEED=$(magick "$WALLPAPER_PATH" -resize 1x1 txt:- | grep -oE '#[0-9a-fA-F]{6}' | head -n 1)
        matugen color hex "$COLOR_SEED" -m dark -t scheme-content
    fi
    wal -n -q -i "$WALLPAPER_PATH"
else
    # Fallback for video wallpapers
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

# Optional browser theming
[[ -x $(command -v pywalfox) ]] && pywalfox update &

if pgrep -x "swaync" > /dev/null; then
    swaync-client -R
    swaync-client -rs
fi

vicinae vicinae://set-theme?id=pywal
# Restart waybar in a new session to avoid hanging the terminal
setsid waybar -c "$CURRENT_CONF" -s "$CURRENT_STYLE" >/dev/null 2>&1 &

notify-send -t 2000 "Theme Synced" "Colors & UI updated for: $choice"

exit 0
