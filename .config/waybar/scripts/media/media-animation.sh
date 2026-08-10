#!/usr/bin/env bash

# "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"

animation_frames=("▂▄▆" "▄▂▆" "▄▆▂" "▆▄▂" "▆▂▄")



while :; do
  for frame in "${animation_frames[@]}"; do
      time=$(playerctl metadata --format '{{duration(position)}}/{{duration(mpris:length)}}' 2>/dev/null)
    status=$(playerctl metadata --format '{{status}}' 2>/dev/null)

    if [ "$status" == "Playing" ]; then
          echo " $time $frame"
    elif [ "$status" == "Paused" ]; then
            echo "▶ $time"
    else
            echo "No Music"
    fi

    sleep 0.1
  done
done
