#!/usr/bin/env bash
# Widget: battery charge (macOS via pmset, Linux via /sys/class/power_supply).
# Disable with `set -g @yorumi_show_battery 0`.
# Silently exits on machines with no battery (desktops) or an unsupported OS.

ENABLED="$(tmux show-option -gv @yorumi_show_battery 2>/dev/null)"
[[ "$ENABLED" == "0" ]] && exit 0

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/theme.sh"

PERCENT=""
IS_CHARGING=0

case "$(uname)" in
"Darwin")
  command -v pmset >/dev/null 2>&1 || exit 0
  PMSET_OUT="$(pmset -g batt)"
  echo "$PMSET_OUT" | grep -q "InternalBattery" || exit 0

  PERCENT="$(echo "$PMSET_OUT" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
  echo "$PMSET_OUT" | grep -q "AC Power" && IS_CHARGING=1
  ;;
"Linux")
  BATTERY_PATH="$(compgen -G '/sys/class/power_supply/BAT*' | head -1)"
  [[ -z "$BATTERY_PATH" ]] && exit 0

  PERCENT="$(<"$BATTERY_PATH/capacity")"
  STATUS="$(<"$BATTERY_PATH/status")"
  [[ "$STATUS" == "Charging" ]] && IS_CHARGING=1
  ;;
*)
  exit 0
  ;;
esac

[[ -z "$PERCENT" ]] && exit 0

CHARGING_ICONS=(󰢜 󰂆 󰂇 󰂈 󰢝 󰂉 󰢞 󰂊 󰂋 󰂅)
DISCHARGING_ICONS=(󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)

IDX=$(( PERCENT / 10 ))
(( IDX > 9 )) && IDX=9

if [[ "$IS_CHARGING" == "1" ]]; then
  ICON="${CHARGING_ICONS[$IDX]}"
else
  ICON="${DISCHARGING_ICONS[$IDX]}"
fi

LOW_THRESHOLD="$(tmux show-option -gv @yorumi_battery_low_threshold 2>/dev/null)"
LOW_THRESHOLD="${LOW_THRESHOLD:-20}"

if [[ "$IS_CHARGING" == "0" && "$PERCENT" -le "$LOW_THRESHOLD" ]]; then
  COLOR="${THEME[accent_red]}"
else
  COLOR="${THEME[accent_blue]}"
fi

echo "#[fg=${THEME[accent_blue]},bg=${THEME[bg_bar]}]░ #[fg=${COLOR}]${ICON} #[fg=${THEME[fg_text]},bg=${THEME[bg_bar]}]${PERCENT}% "
