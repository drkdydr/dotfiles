#!/usr/bin/env bash

width=25
gap="   "

last_text=""
scroll_pos=0

while :; do
  text=$(playerctl -p playerctld metadata --format '{{title}} - {{artist}}' 2>/dev/null)

  if [ -z "$text" ]; then
    echo ""
    last_text=""
    sleep 0.5
    continue
  fi

  if [ "$text" != "$last_text" ]; then
    last_text="$text"
    scroll_pos=0
  fi

  if [ ${#text} -le $width ]; then
    echo "$text"
  else
    full="$text$gap"
    len=${#full}
    doubled="$full$full"
    echo "${doubled:$scroll_pos:$width}"
    scroll_pos=$(( (scroll_pos + 1) % len ))
  fi

  sleep 0.3
done
