#!/usr/bin/env bash 

### AUTOSTART PROGRAMS ###
picom --config ~/.config/picom/picom.conf --daemon &
nm-applet &
blueman-applet & 

### UNCOMMENT ONLY ONE OF THE FOLLOWING THREE OPTIONS! ###
# 3. Uncomment to set wallpaper with nitrogen
nitrogen --restore &
