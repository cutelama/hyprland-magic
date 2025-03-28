#!/bin/bash

CONFIG_INI="$HOME/.config/waypaper/config.ini" # waypaper config
WALLPAPER_PATH=$(grep '^wallpaper =' "$CONFIG_INI" | cut -d '=' -f2- | tr -d ' ' | xargs -I {} echo {})
WALLPAPER_PATH=$(eval echo "$WALLPAPER_PATH")

wal -c
wal -i "$WALLPAPER_PATH"

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


#color1=$(echo "${colors[1]#\#}" | tr '[:upper:]' '[:lower:]')ff
#color6=$(echo "${colors[6]#\#}" | tr '[:upper:]' '[:lower:]')ff
#color7=$(echo "${colors[7]#\#}" | tr '[:upper:]' '[:lower:]')ff
#
#hyprctl keyword general:col.active_border "rgba($color6) rgba($color7) 45deg"
#hyprctl keyword general:col.inactive_border "rgba($color1)"
