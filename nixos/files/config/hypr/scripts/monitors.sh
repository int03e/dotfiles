#!/usr/bin/env bash

# Names from 'hyprctl monitors'
INTERNAL="eDP-1"
EXTERNAL="HDMI-A-1"

handle_monitor_event() {
	# 1. When monitor is ADDED: Move all workspaces to external
	if [[ $1 == monitoradded* ]]; then
		sleep 1 # Give Hyprland a second to initialize the monitor
		hyprctl workspaces -j | jq '.[] | .id' | while read -r ws; do
			hyprctl dispatch moveworkspacetomonitor "$ws $EXTERNAL"
		done
		# Focus the first workspace on the new monitor
		hyprctl dispatch workspace 1
	fi

	# 2. When monitor is REMOVED: Ensure everything is back on internal
	if [[ $1 == monitorremoved* ]]; then
		hyprctl workspaces -j | jq '.[] | .id' | while read -r ws; do
			hyprctl dispatch moveworkspacetomonitor "$ws $INTERNAL"
		done
	fi
}

# Listen to the event socket
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
	handle_monitor_event "$line"
done
