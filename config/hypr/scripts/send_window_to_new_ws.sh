#!/usr/bin/env bash
set -euo pipefail

# Move the currently active window to a freshly created workspace on the focused monitor.
# Mirrors the tested one-liner flow (focus monitor → create workspace → move → return).

focused_mon_json=$(hyprctl monitors -j | jq '.[] | select(.focused == true)')
if [[ -z "$focused_mon_json" ]]; then
  echo "Could not determine focused monitor" >&2
  exit 1
fi

mon_name=$(jq -r '.name' <<<"$focused_mon_json")

active_window_json=$(hyprctl activewindow -j)
if [[ -z "$active_window_json" || "$active_window_json" == "null" ]]; then
  echo "No active window to move" >&2
  exit 0
fi

window_addr=$(jq -r '.address' <<<"$active_window_json")
if [[ -z "$window_addr" || "$window_addr" == "0x0" ]]; then
  echo "Invalid active window address" >&2
  exit 1
fi

current_ws=$(hyprctl activeworkspace -j | jq -r '.id')
if [[ -z "$current_ws" || "$current_ws" == "null" ]]; then
  echo "Could not determine current workspace" >&2
  exit 1
fi

mapfile -t all_ws_ids < <(hyprctl workspaces -j | jq '.[].id' | sort -n)

new_ws_id=1
if ((${#all_ws_ids[@]})); then
  last_idx=$(( ${#all_ws_ids[@]} - 1 ))
  new_ws_id=$(( all_ws_ids[last_idx] + 1 ))
fi

hyprctl --batch \
  "dispatch focusmonitor ${mon_name}; \
   dispatch workspace ${new_ws_id}; \
   dispatch movetoworkspacesilent ${new_ws_id},address:${window_addr}; \
   dispatch focusworkspace ${current_ws}"
