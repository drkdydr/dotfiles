#!/usr/bin/env bash
set -uo pipefail

action_file="$HOME/.cache/waybar-updates-action"
upgrade_marker="$HOME/.cache/waybar-last-upgrade"

boot_epoch=$(awk '/^btime/{print $2}' /proc/stat)

# Bu oturumda gerçekten bir upgrade yapılmış mı?
upgrade_happened_this_boot=false
if [ -f "$upgrade_marker" ]; then
    marker_epoch=$(stat -c %Y "$upgrade_marker")
    if [ "$marker_epoch" -gt "$boot_epoch" ]; then
        upgrade_happened_this_boot=true
    fi
fi

output=$(timeout 15 dnf check-update --quiet 2>&1)
rc=$?
if [ "$rc" -eq 124 ]; then
    echo "" > "$action_file"
    jq -nc '{text: "⚠", tooltip: "dnf check-update did not respond (timeout)", class: "error"}'
    exit 0
fi

# needs-restarting'i SADECE bu oturumda gerçek bir upgrade yapıldıysa dikkate al
if [ "$upgrade_happened_this_boot" = true ]; then
    restart_output=$(timeout 5 dnf --cacheonly needs-restarting -r 2>&1)
    restart_rc=$?
    if [ "$restart_rc" -eq 124 ]; then
        echo "" > "$action_file"
        jq -nc '{text: "⚠", tooltip: "needs-restarting did not respond (timeout)", class: "error"}'
        exit 0
    fi
    if [ "$restart_rc" -eq 1 ]; then
        echo "reboot" > "$action_file"
        jq -nc '{text: "⟳", tooltip: "Waiting for reboot", class: "reboot-needed"}'
        exit 0
    fi
    if [ "$restart_rc" -gt 1 ]; then
        echo "" > "$action_file"
        tooltip=$(echo "$restart_output" | sed ':a;N;$!ba;s/\n/\\n/g')
        jq -nc --arg tooltip "$tooltip" \
            '{text: "⚠", tooltip: ("needs-restarting could not work:\n" + $tooltip), class: "error"}'
        exit 0
    fi
fi

if [ "$rc" -eq 0 ]; then
    echo "" > "$action_file"
    jq -nc '{text: "✔", tooltip: "Up to date", class: "up-to-date"}'
elif [ "$rc" -eq 100 ]; then
    echo "kitty -e ~/.config/waybar/scripts/updates/do-upgrade.sh" > "$action_file"
    count=$(echo "$output" | awk 'NF>=3' | grep -c .)
    jq -nc --arg count "$count" \
        '{text: "⬆", tooltip: ($count + " updates available"), class: "has-updates"}'
else
    echo "" > "$action_file"
    jq -nc '{text: "⚠", tooltip: "check-update failed", class: "error"}'
fi
