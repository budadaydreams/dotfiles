#!/bin/zsh
pkill waybar
sleep 0.5

m=$(printenv LAPTOP)

if [ $m = 1 ]; then
   waybar --config /home/guto/.config/waybar/laptop-bar/config.jsonc --style /home/guto/.config/waybar/laptop-bar/style.css
else
   waybar --config /home/guto/.config/waybar/desktop-bar/config.jsonc --style /home/guto/.config/waybar/desktop-bar/style.css
fi
