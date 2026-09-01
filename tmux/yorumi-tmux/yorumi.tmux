#!/usr/bin/env bash
#
# yorumi — a small, script-driven tmux status bar theme.
# Layout mirrors janoamaral/tokyo-night-tmux: this file wires up static
# options and dynamic widgets; each scripts/*.sh is a self-contained widget
# toggled by its own `@yorumi_show_*` tmux option.

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_PATH="$CURRENT_DIR/scripts"

source "$SCRIPTS_PATH/theme.sh"

# --- STATUS BAR GENERAL ---
tmux set-option -g status-position bottom
tmux set-option -g status-justify left
tmux set-option -g status-style "bg=${THEME[bg_bar]},fg=${THEME[fg_text]}"
tmux set-option -g status-left-length 40
tmux set-option -g status-right-length 150

# --- STATUS LEFT (Session Pill, powerline-style) ---
# ARROW is the powerline solid triangle. For a transition FROM color A TO
# color B (reading left to right) it's printed as fg=A,bg=B; for a transition
# back OUT of a colored segment onto the plain bar it's fg=<segment color>,bg=bar.
ARROW=$''
tmux set-option -g status-left "#[fg=${THEME[bg_dark]},bg=${THEME[accent_cream]},bold]  #S #[fg=${THEME[accent_cream]},bg=${THEME[bg_bar]}]${ARROW}#[default]"

# --- WINDOW TABS ---
# Each window is its own self-contained pill (opens + closes its own powerline
# arrows), so tabs look distinct from each other and from the bar regardless
# of which neighbor is active — no need to special-case adjacency.
window_number="#($SCRIPTS_PATH/window-number.sh #I)"
ssh_icon="#{?#{==:#{pane_current_command},ssh},󰣀 ,}"
panes_icon="#{?#{>:#{window_panes},1}, ,}"
zoom_icon="#{?window_zoomed_flag, 󰊓,}"
last_icon="#{?window_last_flag, 󰁯,}"

# Inactive: dim pill, filled with bg_surface so it still reads as a boxed tab
tmux set-option -g window-status-format "#[fg=${THEME[bg_bar]},bg=${THEME[bg_surface]}]${ARROW}#[fg=${THEME[fg_muted]},bg=${THEME[bg_surface]}] ${ssh_icon}${window_number} #W${panes_icon}${zoom_icon}${last_icon} #[fg=${THEME[bg_surface]},bg=${THEME[bg_bar]}]${ARROW}#[default]"

# Active: pink pill — distinct from the session pill's green.
tmux set-option -g window-status-current-format "#[fg=${THEME[bg_bar]},bg=${THEME[accent_red]}]${ARROW}#[fg=${THEME[bg_dark]},bg=${THEME[accent_red]},bold] ${ssh_icon}${window_number} #W${panes_icon}${zoom_icon}${last_icon} #[fg=${THEME[accent_red]},bg=${THEME[bg_bar]}]${ARROW}#[default]"

# Between tabs: each tab already closes/opens its own pill, so just a gap
tmux set-option -g window-status-separator " "

# --- STATUS RIGHT (widgets, left to right: path, git, datetime, battery) ---
current_path="#($SCRIPTS_PATH/path.sh #{q:pane_current_path})"
git_status="#($SCRIPTS_PATH/git-status.sh #{q:pane_current_path})"
date_and_time="#($SCRIPTS_PATH/datetime.sh)"
battery_status="#($SCRIPTS_PATH/battery.sh)"

tmux set-option -g status-right "${current_path}${git_status}${date_and_time}${battery_status}"

# --- PANE BORDERS & SELECTION ---
tmux set-option -g pane-border-style "fg=${THEME[bg_surface]}"
tmux set-option -g pane-active-border-style "fg=${THEME[accent_blue]}"
tmux set-option -g mode-style "bg=${THEME[bg_select]},fg=${THEME[accent_cream]}"

# --- COMMAND PROMPT (`:`) ---
# Muted, matching the bar itself, not a bright accent block. fill= is patched
# in generically by ../fix-message-fill.tmux, sourced last in tmux.conf — no
# need to set it here.
tmux set-option -g message-style "bg=${THEME[bg_surface]},fg=${THEME[accent_blue]}"
tmux set-option -g message-command-style "bg=${THEME[bg_surface]},fg=${THEME[accent_blue]}"
