#!/usr/bin/env bash
#
# tmux's message-style/message-command-style don't default to fill=<bg>, so
# the `:` command prompt only paints its own text cells and the status bar's
# background shows through underneath it. This isn't specific to any one
# theme's palette — every theme hits it. Rather than hardcode a copy of the
# theme's colors here, derive fill= from whatever bg= the active theme
# already set, so this file never needs edits when the theme changes.
#
# Must run AFTER the active theme sets message-style/message-command-style
# (i.e. sourced last in tmux.conf).

add_fill() {
  local style="$1"
  # already has fill= (e.g. set explicitly by the theme) -> leave it alone
  [[ "$style" == *fill=* ]] && { echo "$style"; return; }

  local bg
  bg="$(echo "$style" | grep -oE 'bg=[^,]+' | head -1 | cut -d= -f2)"
  [[ -z "$bg" ]] && { echo "$style"; return; }

  echo "${style},fill=${bg}"
}

message_style="$(tmux show-option -gv message-style 2>/dev/null)"
message_command_style="$(tmux show-option -gv message-command-style 2>/dev/null)"

[[ -n "$message_style" ]] && tmux set-option -g message-style "$(add_fill "$message_style")"
[[ -n "$message_command_style" ]] && tmux set-option -g message-command-style "$(add_fill "$message_command_style")"
