#!/usr/bin/env bash
action_file="$HOME/.cache/waybar-updates-action"
if [ -s "$action_file" ]; then
    action=$(cat "$action_file")
    eval "$action"
fi
