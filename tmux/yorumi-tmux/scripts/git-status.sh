#!/usr/bin/env bash
# Widget: branch + dirty indicator for the current pane's repo, if any.
# Disable with `set -g @yorumi_show_git 0`.

ENABLED="$(tmux show-option -gv @yorumi_show_git 2>/dev/null)"
[[ "$ENABLED" == "0" ]] && exit 0

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/theme.sh"

cd "$1" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

BRANCH="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
[[ -z "$BRANCH" ]] && exit 0
if [[ ${#BRANCH} -gt 20 ]]; then
  BRANCH="${BRANCH:0:20}…"
fi

if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
  DOT_COLOR="${THEME[accent_yellow]}"
else
  DOT_COLOR="${THEME[accent_cream]}"
fi

echo "#[fg=${THEME[accent_blue]},bg=${THEME[bg_bar]}]░ #[fg=${DOT_COLOR}]●#[fg=${THEME[fg_text]},bg=${THEME[bg_bar]}] ${BRANCH} "
