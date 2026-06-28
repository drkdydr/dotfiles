# script to auto refresh changes in waybar (for testing)
while inotifywait -e close_write ~/.config/waybar; do killall -SIGUSR2 waybar; done
