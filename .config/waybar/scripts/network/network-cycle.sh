#!/usr/bin/env bash
# ~/.config/waybar/scripts/network-cycle.sh
#
# Sag tik ile wifi / indirme (download) / yukleme (upload) arasinda
# gecis yapan waybar custom modulu.
#
# Kurulum:
#   mkdir -p ~/.config/waybar/scripts
#   cp network-cycle.sh ~/.config/waybar/scripts/
#   chmod +x ~/.config/waybar/scripts/network-cycle.sh
#
# waybar config.jsonc'e ekle:
#   "custom/network": {
#       "exec": "~/.config/waybar/scripts/network-cycle.sh",
#       "on-click-right": "~/.config/waybar/scripts/network-cycle.sh --toggle",
#       "on-click": "exec kitty --title=impala -e impala",
#       "return-type": "json",
#       "interval": 3,
#       "signal": 8
#   }
#
# Not: --signal 8 -> "signal": 8 ile eslesmeli.

set -euo pipefail

STATE_FILE="$HOME/.cache/waybar-network-mode"

# --- Sag tik: sadece modu degistir ve waybar'i aninda guncelle ---
if [[ "${1:-}" == "--toggle" ]]; then
    mode=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
    mode=$(( (mode + 1) % 3 ))
    echo "$mode" > "$STATE_FILE"
    pkill -RTMIN+8 waybar 2>/dev/null || true
    exit 0
fi

mode=$(cat "$STATE_FILE" 2>/dev/null || echo 0)

# --- Varsayilan (internete cikan) interface'i bul ---
iface=$(ip route show default 2>/dev/null | awk '/default/ {print $5; exit}')

# --- Baglanti tipini belirle: wifi / ethernet / disconnected ---
if [[ -z "$iface" ]]; then
    conn_type="disconnected"
elif [[ -d "/sys/class/net/$iface/wireless" ]]; then
    conn_type="wifi"
else
    conn_type="ethernet"
fi

human_rate() {
    local bytes=$1
    if (( bytes > 1048576 )); then
        awk -v b="$bytes" 'BEGIN{printf "%.1f MB/s", b/1048576}'
    else
        awk -v b="$bytes" 'BEGIN{printf "%.0f KB/s", b/1024}'
    fi
}

# --- Wifi bilgisini sirayla dene: iwd (iwctl) -> NetworkManager (nmcli) -> wireless-tools (iwgetid) ---
get_wifi_info() {
    local dev="$1"
    local essid="" signal="" out rssi

    # 1) iwd / impala kullananlar icin
    if command -v iwctl >/dev/null 2>&1; then
        out=$(iwctl station "$dev" show 2>/dev/null || true)
        if [[ -n "$out" ]]; then
            essid=$(echo "$out" | sed -nE 's/^[[:space:]]*Connected network[[:space:]]+(.*[^[:space:]])[[:space:]]*$/\1/p')
            rssi=$(echo "$out" | sed -nE 's/^[[:space:]]*RSSI[[:space:]]+(-?[0-9]+).*/\1/p')
            if [[ -n "$rssi" ]]; then
                if   (( rssi <= -100 )); then signal=0
                elif (( rssi >= -50 ));  then signal=100
                else signal=$(( 2 * (rssi + 100) )); fi
            fi
        fi
    fi

    # 2) NetworkManager kullananlar icin
    if [[ -z "$essid" ]] && command -v nmcli >/dev/null 2>&1; then
        essid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '$1=="yes"{$1=""; sub(/^:/,""); print}')
        if [[ -z "$signal" ]]; then
            signal=$(nmcli -t -f active,signal dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2; exit}')
        fi
    fi

    # 3) wireless-tools kullananlar icin
    if [[ -z "$essid" ]] && command -v iwgetid >/dev/null 2>&1; then
        essid=$(iwgetid -r 2>/dev/null || true)
    fi

    printf '%s|%s' "${essid:-Bilinmiyor}" "${signal:-0}"
}

# --- Eski simgeler (orijinal config ile ayni) ---
ICON_WIFI="<span color='#d9dadd'> </span>"
ICON_ETHERNET="<span color='#d9dadd'> </span>"
ICON_DISCONNECTED="<span color='#999a9e'>󰖪 </span>"
ICON_DOWNLOAD="<span color='#d9dadd'> </span>"
ICON_UPLOAD="<span color='#d9dadd'> </span>"

# --- Tooltip: baglanti durumuna gore, eski tooltip-format'lar ile ayni ---
case "$conn_type" in
    wifi)
        wifi_info=$(get_wifi_info "$iface")
        essid="${wifi_info%%|*}"
        signal="${wifi_info##*|}"
        tooltip="${essid} (${signal}%)"
        ;;
    ethernet)
        tooltip="${iface}"
        ;;
    disconnected)
        tooltip="No Network"
        ;;
esac

# --- Ana metin: mod'a gore ---
if [[ "$mode" == "0" ]]; then
    case "$conn_type" in
        wifi)         text="$ICON_WIFI" ;;
        ethernet)     text="$ICON_ETHERNET" ;;
        disconnected) text="$ICON_DISCONNECTED" ;;
    esac
elif [[ "$conn_type" == "disconnected" ]]; then
    # Baglanti yoksa hiz olcmenin anlami yok, disconnected simgesini goster
    text="$ICON_DISCONNECTED"
else
    rx_path="/sys/class/net/$iface/statistics/rx_bytes"
    tx_path="/sys/class/net/$iface/statistics/tx_bytes"

    rx1=$(cat "$rx_path" 2>/dev/null || echo 0)
    tx1=$(cat "$tx_path" 2>/dev/null || echo 0)
    sleep 1
    rx2=$(cat "$rx_path" 2>/dev/null || echo 0)
    tx2=$(cat "$tx_path" 2>/dev/null || echo 0)

    down_bps=$(( rx2 - rx1 ))
    up_bps=$(( tx2 - tx1 ))

    if [[ "$mode" == "1" ]]; then
        text="$ICON_DOWNLOAD $(human_rate "$down_bps")"
    else
        text="$ICON_UPLOAD $(human_rate "$up_bps")"
    fi
fi

printf '{"text": "%s", "tooltip": "%s"}\n' "$text" "$tooltip"
