#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <dir_name>"
  exit 1
fi

DIR_NAME="$1"
BASE=""
TARGET="$BASE$DIR_NAME"

if [ ! -d "$TARGET" ]; then
  echo "Error: directory $TARGET does not exist: $TARGET"
  exit 2
fi

SESSION="proj-$DIR_NAME"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "Session $SESSION already exists. Attaching..."
  tmux attach -t "$SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -c "$TARGET" -n "Vim"

tmux new-window -t "$SESSION" -c "$TARGET"  -n "Shell"
tmux new-window -t "$SESSION" -c "$TARGET"  -n "Compile"
tmux new-window -t "$SESSION" -c "$TARGET"  -n "Debug"

tmux send-keys -t "${SESSION}:Vim" "vim ." C-m
tmux select-window -t "${SESSION}:Vim" 

tmux attach -t "$SESSION"

