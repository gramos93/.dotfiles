#!/usr/bin/env bash
# Renders a window/pane index using tokyo-night's Nerd Font "square digit"
# icons instead of plain ASCII digits.

DIGITS="󰎣󰎦󰎩󰎬󰎮󰎰󰎵󰎸󰎻󰎾"
ID="$1"

for ((i = 0; i < ${#ID}; i++)); do
  D="${ID:i:1}"
  [[ "$D" =~ [0-9] ]] || { printf '%s' "$D"; continue; }
  printf '%s' "${DIGITS:D:1}"
done
