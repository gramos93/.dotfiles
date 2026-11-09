#!/usr/bin/env bash
# Runs after every tmux-resurrect save (@resurrect-hook-post-save-all).
# Records "<session>:<window>.<pane><TAB><session.jsonl>" for each pane running
# a live omp, found via the session file the omp process holds open.
out="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect/omp-sessions.tsv"
tmp="$out.tmp"
: > "$tmp"

tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}	#{pane_tty}' |
while IFS=$'\t' read -r key tty; do
	for pid in $(ps -t "${tty#/dev/}" -o pid=,args= | awk '$2 ~ /(^|\/)omp$/ && $3 !~ /^__omp/ {print $1}'); do
		file=$(lsof -p "$pid" -Fn 2>/dev/null | sed -n 's/^n//p' | grep -E '/\.omp/agent/sessions/[^/]+/[^/]+\.jsonl$' | head -1)
		[ -n "$file" ] && printf '%s\t%s\n' "$key" "$file" >> "$tmp"
	done
done

mv "$tmp" "$out"
