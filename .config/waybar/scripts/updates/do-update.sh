#!/usr/bin/env bash
if sudo pacman -Syu; then
    touch "$HOME/.cache/waybar-last-upgrade"
fi
echo "Press a key to continue..."
read -n 1
