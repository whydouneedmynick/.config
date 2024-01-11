#!/usr/bin/env bash
# IGNORE_PATH
set -xe

session_name="notes"

tmux send-keys -t "$session_name:1" "cd $HOME/notes; nvim -c 'Telescope find_files'" Enter
