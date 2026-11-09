#!/usr/bin/env bash
# Sent into a pane by tmux-resurrect on restore ("omp->.../omp-resume.sh").
# Resumes the exact omp session that pane had at save time; falls back to --continue.
map="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect/omp-sessions.tsv"
key=$(tmux display-message -p -t "$TMUX_PANE" '#{session_name}:#{window_index}.#{pane_index}')
file=$(awk -F'\t' -v k="$key" '$1 == k {print $2; exit}' "$map" 2>/dev/null)

if [ -n "$file" ] && [ -f "$file" ]; then
	exec omp --resume "$file"
fi
exec omp --continue
