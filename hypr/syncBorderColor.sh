#!/bin/bash
#
#WALLPAPER=$(find "$HOME/Pics/Wallpapers/" -type f | shuf -n 1)
#ANGLE=$((RANDOM % 360))
#TRANSITION="--transition-type wave --transition-angle $ANGLE --transition-fps 120"
#
#awww img "$WALLPAPER" $TRANSITION
#
#cp "$WALLPAPER" "$XDG_CONFIG_HOME/hypr/hyprlock.png"
#
#sleep 2
#
#wal -c
#wal -i "$WALLPAPER"
#
#COLORS_SOURCE="$HOME/.cache/wal/colors"
#CONFIG_FILE="$XDG_CONFIG_HOME/hypr/colors.conf"
#TMP_FILE=$(mktemp)
#
#{
#    index=0
#    while [ $index -lt 16 ] && read -r color; do
#        formatted_color="$(echo "${color#\#}" | tr '[:upper:]' '[:lower:]')ff"
#        echo "\$color$index = $formatted_color"
#        ((index++))
#    done < "$COLORS_SOURCE"
#} > "$TMP_FILE"
#
#mv -f "$TMP_FILE" "$CONFIG_FILE" # bypass text of hyprland_config_error
#
#echo "Colors successfully updated in $CONFIG_FILE"
#
#!/bin/bash

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
CACHE_DIR="$HOME/.cache/wal"
WALLPAPER_DIR="$HOME/Pics/Wallpapers/"

if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Directory $WALLPAPER_DIR does not exist."
    exit 1
fi

WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" -o -name "*.gif" \) | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
    echo "Error: No wallpapers found."
    exit 1
fi

ANGLE=$((RANDOM % 360))
awww img "$WALLPAPER" --transition-type wave --transition-angle $ANGLE --transition-fps 120 &

cp "$WALLPAPER" "$CONFIG_DIR/hyprlock.png"

wal -n -q -i "$WALLPAPER"

COLORS_SOURCE="$CACHE_DIR/colors"
CONFIG_FILE="$CONFIG_DIR/colors.conf"
TMP_FILE=$(mktemp)

if [ ! -f "$COLORS_SOURCE" ]; then
    echo "Error: Wal did not generate colors."
    rm "$TMP_FILE"
    exit 1
fi

{
    index=0
    while read -r color; do
        clean_color=$(echo "${color#\#}" | tr '[:upper:]' '[:lower:]')
        formatted_color="${clean_color}ff"

        echo "\$color$index = rgba($formatted_color)"

        ((index++))

        if [ $index -ge 16 ]; then break; fi
    done < "$COLORS_SOURCE"
} > "$TMP_FILE"

mv -f "$TMP_FILE" "$CONFIG_FILE"

echo "Success: Wallpaper set to $WALLPAPER and colors updated."
