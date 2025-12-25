#!/usr/bin/env bash
set -euo pipefail

# Per-monitor workspace switcher for Hyprland.
# Moves to the next/prev workspace that belongs to the focused monitor.
# Falls back to creating a new workspace (next) or stopping (prev) without looping.

direction="${1:-next}"

if [[ "$direction" != "next" && "$direction" != "prev" ]]; then
  echo "usage: $0 [next|prev]" >&2
  exit 2
fi

focused_mon_json=$(hyprctl monitors -j | jq '.[] | select(.focused == true)')
if [[ -z "$focused_mon_json" ]]; then
  echo "Could not determine focused monitor" >&2
  exit 1
fi

mon_id=$(jq -r '.id' <<<"$focused_mon_json")
mon_name=$(jq -r '.name' <<<"$focused_mon_json")

current_ws=$(hyprctl activeworkspace -j | jq -r '.id')
if [[ -z "$current_ws" ]]; then
  echo "Could not determine active workspace" >&2
  exit 1
fi

mapfile -t all_ws_ids < <(hyprctl workspaces -j | jq '.[].id' | sort -n)
mapfile -t mon_ws_ids < <(hyprctl workspaces -j | jq --argjson mon "$mon_id" '.[] | select(.monitorID == $mon) | .id' | sort -n)

all_max=""
if ((${#all_ws_ids[@]})); then
  all_max="${all_ws_ids[-1]}"
fi

case "$direction" in
  next)
    for id in "${mon_ws_ids[@]}"; do
      if (( id > current_ws )); then
        hyprctl dispatch workspace "$id"
        exit 0
      fi
    done

    if [[ -z "$all_max" ]]; then
      new_id=1
    else
      new_id=$((all_max + 1))
    fi

    hyprctl dispatch workspace "$new_id"
    ;;

  prev)
    for ((idx=${#mon_ws_ids[@]}-1; idx>=0; idx--)); do
      id="${mon_ws_ids[$idx]}"
      if (( id < current_ws )); then
        hyprctl dispatch workspace "$id"
        exit 0
      fi
    done

    if command -v notify-send >/dev/null 2>&1; then
      notify-send "Hyprland" "Reached first workspace on ${mon_name}"
    fi
    ;;
esac
