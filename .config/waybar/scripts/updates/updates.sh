#!/usr/bin/env bash
set -uo pipefail

action_file="$HOME/.cache/waybar-updates-action"
upgrade_marker="$HOME/.cache/waybar-last-upgrade"

boot_epoch=$(awk '/^btime/{print $2}' /proc/stat)

# Bu oturumda gercekten bir upgrade yapilmis mi?
upgrade_happened_this_boot=false
if [ -f "$upgrade_marker" ]; then
    marker_epoch=$(stat -c %Y "$upgrade_marker")
    if [ "$marker_epoch" -gt "$boot_epoch" ]; then
        upgrade_happened_this_boot=true
    fi
fi

output=$(timeout 15 checkupdates 2>&1)
rc=$?

# GNU timeout gercekten oldurduyse (15sn asildi) rc=124 olur; bunu
# checkupdates'in kendi "bilinmeyen hata" kodu olan 1'den ayirt ediyoruz.
if [ "$rc" -eq 124 ]; then
    echo "" > "$action_file"
    jq -nc '{text: "⚠", tooltip: "checkupdates did not respond (timeout)", class: "error"}'
    exit 0
fi

# checkupdates exit kodlari (dnf check-update ile TERSTIR):
#   0 = guncelleme(ler) bulundu ve listelendi
#   1 = bilinmeyen hata (ag, veritabani kilidi vb.)
#   2 = guncelleme yok
if [ "$rc" -eq 1 ]; then
    echo "" > "$action_file"
    jq -nc '{text: "⚠", tooltip: "checkupdates failed", class: "error"}'
    exit 0
fi

# needs-restarting'i SADECE bu oturumda gercek bir upgrade yapildiysa dikkate al
if [ "$upgrade_happened_this_boot" = true ]; then
    # Arch'ta dnf yok. Su an calisan kernel'in modul dizini hala diskte mi diye
    # bakiyoruz: pacman yeni bir kernel paketi kurunca eski surumun
    # /usr/lib/modules/<surum> dizinini siler; o dizin yoksa artik diskten
    # silinmis/eski bir kernel'de calisiyoruz demektir -> reboot gerekir.
    # Bu yontem linux, linux-lts, linux-zen gibi hangi kernel paketini
    # kullandiginizdan bagimsiz calisir, cunku dogrudan `uname -r` ile
    # eslesen dizine bakar.
    # Not: "linux-preserve-modules" gibi eski modulleri disarida tutan bir
    # AUR paketiniz varsa bu kontrol reboot gerekliligini kacirabilir.
    running_kernel=$(uname -r)
    if [ ! -d "/usr/lib/modules/$running_kernel" ]; then
        echo "reboot" > "$action_file"
        jq -nc '{text: "⟳", tooltip: "Waiting for reboot", class: "reboot-needed"}'
        exit 0
    fi
fi

if [ "$rc" -eq 2 ]; then
    echo "" > "$action_file"
    jq -nc '{text: "✔", tooltip: "Up to date", class: "up-to-date"}'
elif [ "$rc" -eq 0 ]; then
    echo "kitty -e ~/.config/waybar/scripts/updates/do-update.sh" > "$action_file"
    count=$(echo "$output" | awk 'NF>=3' | grep -c .)
    jq -nc --arg count "$count" \
        '{text: "", tooltip: ($count + " updates available"), class: "has-updates"}'
else
    echo "" > "$action_file"
    jq -nc '{text: "⚠", tooltip: "checkupdates returned an unexpected exit code", class: "error"}'
fi
