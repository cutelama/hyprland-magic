#!/bin/bash

WALLPAPER=$(find "$HOME/Docs/Pics/Wallpapers/" -type f | shuf -n 1)
ANGLE=$((RANDOM % 360))
TRANSITION="--transition-type wave --transition-angle $ANGLE --transition-fps 120"

swww img "$WALLPAPER" $TRANSITION

sleep 2

wal -c
wal -i "$WALLPAPER"

COLORS_SOURCE="$HOME/.cache/wal/colors"
CONFIG_FILE="$HOME/.config/hypr/colors.conf"
TMP_FILE=$(mktemp)

{
    index=0
    while [ $index -lt 16 ] && read -r color; do
        formatted_color="$(echo "${color#\#}" | tr '[:upper:]' '[:lower:]')ff"
        echo "\$color$index = $formatted_color"
        ((index++))
    done < "$COLORS_SOURCE"
} > "$TMP_FILE"

mv -f "$TMP_FILE" "$CONFIG_FILE" # bypass text of hyprland_config_error

echo "Colors successfully updated in $CONFIG_FILE"


