#!/usr/bin/env bash
# IGNORE_PATH
session_name="music"
tmux send-keys -t "$session_name":1 "cd $HOME/Music; ranger" Enter

