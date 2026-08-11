#!/usr/bin/env bash

# "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"

animation_frames=("▂▄▆" "▄▂▆" "▄▆▂" "▆▄▂" "▆▂▄")

while :; do
  for frame in "${animation_frames[@]}"; do
    # Tek cagriya indirdik: eskiden metadata iki ayri playerctl cagrisiyla
    # (biri sure, biri status icin) okunuyordu; bu hem gereksiz surec/D-Bus
    # yukuydu hem de iki cagri arasinda parca degisirse tutarsiz veri riski
    # tasiyordu.
    #
    # default(..., 0): bazi oynaticilar (tarayici sekmeleri, radyo/canli
    # yayin akislari, ya da parca henuz tam yuklenmemisken) mpris:length
    # (bazen position) alanini hic gondermez. Bu durumda playerctl bu
    # degiskeni bos string olarak genisletir ve duration() de bos cikti
    # uretir -> "0:00/" seklinde yarim/takili gorunum. default() ile
    # eksik deger sayisal bir varsayilana (0) dusuruluyor, boylece
    # duration() her zaman gecerli bir "0:00" formati basiyor.
    IFS='|' read -r time status < <(playerctl metadata \
      --format '{{duration(default(position,0))}}/{{duration(default(mpris:length,0))}}|{{status}}' \
      2>/dev/null)

    if [ "$status" == "Playing" ]; then
      echo "⏸ $time $frame ♫"
    elif [ "$status" == "Paused" ]; then
      echo "▶ $time ♫"
    else
      echo "♪ No Music"
    fi

    sleep 0.1
  done
done
