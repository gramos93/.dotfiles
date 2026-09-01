#!/usr/bin/env bash
# Widget: current pane path. Disable with `set -g @yorumi_show_path 0`.

ENABLED="$(tmux show-option -gv @yorumi_show_path 2>/dev/null)"
[[ "$ENABLED" == "0" ]] && exit 0

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/theme.sh"

current_path="${1/#$HOME/\~}"

echo "#[fg=${THEME[accent_cream]},bg=${THEME[bg_bar]}]░  #[fg=${THEME[fg_text]},bg=${THEME[bg_bar]}]${current_path} "
