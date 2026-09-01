#!/usr/bin/env bash
# Widget: date + time. Disable with `set -g @yorumi_show_datetime 0`.
# Format with `set -g @yorumi_date_format '...'` / `@yorumi_time_format '...'`
# (strftime patterns, see `man strftime`).

ENABLED="$(tmux show-option -gv @yorumi_show_datetime 2>/dev/null)"
[[ "$ENABLED" == "0" ]] && exit 0

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/theme.sh"

DATE_FORMAT="$(tmux show-option -gv @yorumi_date_format 2>/dev/null)"
DATE_FORMAT="${DATE_FORMAT:-%Y-%m-%d}"
TIME_FORMAT="$(tmux show-option -gv @yorumi_time_format 2>/dev/null)"
TIME_FORMAT="${TIME_FORMAT:-%H:%M}"

echo "#[fg=${THEME[accent_blue]},bg=${THEME[bg_bar]}]░ 󰥔 #[fg=${THEME[fg_text]},bg=${THEME[bg_bar]}]$(date "+${DATE_FORMAT} ${TIME_FORMAT}") "
