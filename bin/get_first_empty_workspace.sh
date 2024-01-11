#!/usr/bin/env bash

hyprctl workspaces -j \
	| xq '.[].id' \
	| sort \
	| awk 'BEGIN { getline prev }
	       { cur = $1; if ((cur - prev) > 1) { print prev+1; exit } prev = cur }
	       END { if (cur == prev) { print cur+1 } }'
