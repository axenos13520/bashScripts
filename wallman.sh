#!/bin/bash
WALLPAPER_DIR="$HOME/assets/wallpaper"

if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1
fi

while true; do
    for wp in "$WALLPAPER_DIR"/*; do
        [ -f "$wp" ] || continue
        swww img "$wp" --transition-type fade 
        sleep 1800
    done
done

