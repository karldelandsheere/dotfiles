#!/usr/bin/env bash
# [[ -z $NIRI_SOCKET ]] && exit 1

# while true; do
    # icons="$(niri msg --json workspaces | \
    #     jq -c 'if .[].is_active then "󰪥" else "󰄰" end' | \
    #     awk '{ printf "%s\\n", $0 }' | \
    #     tr -d \" | \
    #     sed 's/.\{2\}$//')"
    # echo "\"$icons\"" | jq -c '{ text: "\(.)" }'
    # sleep 1
# done
