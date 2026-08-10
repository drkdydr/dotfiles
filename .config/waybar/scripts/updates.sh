#!/usr/bin/env bash
# Waybar: dnf5 guncelleme + yeniden baslatma gerekliligi gostergesi (Fedora)
set -uo pipefail

# --- 1) yeniden baslatma gerekiyor mu? (dnf5: "dnf needs-restarting", sudo GEREKMEZ) ---
# timeout: polkit/D-Bus yetkilendirmesi grafik ortamda takilirsa script sonsuza
# kadar asilmasin, 5sn sonra vazgecip hata durumuna dussun
restart_output=$(timeout 5 dnf needs-restarting -r 2>&1)
restart_rc=$?
if [ "$restart_rc" -eq 124 ]; then
    jq -nc '{text: "⚠", tooltip: "needs-restarting did not respond (timeout)", class: "error"}'
    exit 0
fi

if [ "$restart_rc" -eq 1 ]; then
    jq -nc '{text: "⟳", tooltip: "Waiting for reboot", class: "reboot-needed"}'
    exit 0
fi

if [ "$restart_rc" -gt 1 ]; then
    tooltip=$(echo "$restart_output" | sed ':a;N;$!ba;s/\n/\\n/g')
    jq -nc --arg tooltip "$tooltip" \
        '{text: "⚠", tooltip: ("needs-restarting could not work:\n" + $tooltip), class: "error"}'
    exit 0
fi

# --- 2) bekleyen paket guncellemesi var mi? ---
output=$(dnf check-update --quiet 2>/dev/null)
rc=$?

if [ "$rc" -eq 0 ]; then
    jq -nc '{text: "⬆", tooltip: "Up to date", class: "up-to-date"}'
elif [ "$rc" -eq 100 ]; then
    count=$(echo "$output" | awk 'NF>=3' | grep -c .)
    jq -nc --arg count "$count" \
        '{text: "⬆", tooltip: ($count + " updates available"), class: "has-updates"}'
else
    jq -nc '{text: "⬆", tooltip: "dnf check-update failed", class: "error"}'
fi
