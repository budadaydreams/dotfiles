#!/bin/zsh

HDMI=$(cat /sys/class/drm/card1-HDMI-A-1/status)

if [ "$HDMI" = 'disconnected' ]; then
        export LAPTOP=1
else
        export LAPTOP=0
fi

if [ "$(tty)" = "/dev/tty1" ];then
	setsid hyprland > /dev/null 2>&1 
fi
