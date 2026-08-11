#!/usr/bin/env bash
# Waybar: dnf5 guncelleme + yeniden baslatma gerekliligi gostergesi (Fedora)
set -uo pipefail

# --- 1) bekleyen paket guncellemesi var mi? ---
# NOT: dnf5 hemen her alt komutta repo metadata'sini tazelemeye calisir
# ("Updating and loading repositories"). Bu yuzden agi SADECE burada,
# tek seferde yoralim; asagidaki needs-restarting cagrisi ayni onbellegi
# --cacheonly ile kullanacagi icin tekrar aga cikmayacak.
# Timeout'u check-update icin daha comert tuttuk cunku asil ag gecikmesi
# burada yasaniyor; needs-restarting artik lokal oldugu icin kisa timeout yeterli.
output=$(timeout 15 dnf check-update --quiet 2>&1)
rc=$?

if [ "$rc" -eq 124 ]; then
    jq -nc '{text: "⚠", tooltip: "dnf check-update did not respond (timeout)", class: "error"}'
    exit 0
fi

# --- 2) yeniden baslatma gerekiyor mu? ---
# --cacheonly: adim 1'de zaten tazelenen metadata'yi kullan, tekrar aga cikma.
# Boylece bu cagri her zaman hizli olur ve zaman asimina takilmaz.
# (sudo GEREKMEZ)
restart_output=$(timeout 5 dnf --cacheonly needs-restarting -r 2>&1)
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

# --- 3) sonuc: guncelleme var mi / yok mu (adim 1'in sonucuna gore) ---
if [ "$rc" -eq 0 ]; then
    jq -nc '{text: "✔", tooltip: "Up to date", class: "up-to-date"}'
elif [ "$rc" -eq 100 ]; then
    count=$(echo "$output" | awk 'NF>=3' | grep -c .)
    jq -nc --arg count "$count" \
        '{text: "⬆", tooltip: ($count + " updates available"), class: "has-updates"}'
else
    jq -nc '{text: "⚠", tooltip: "dnf check-update failed", class: "error"}'
fi
