#!/usr/bin/env bash
if sudo dnf upgrade; then
    touch "$HOME/.cache/waybar-last-upgrade"
fi
echo "Devam etmek için bir tuşa bas..."
read -n 1
