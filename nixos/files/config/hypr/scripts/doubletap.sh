#!/run/current-system/sw/bin/bash

# Time threshold in seconds (0.4 is usually perfect)
THRESHOLD=0.4
STATE_FILE="/tmp/hypr_last_press"
COMMAND="wofi --show drun"

NOW=$(date +%s.%N)

if [ -f "$STATE_FILE" ]; then
	LAST_PRESS=$(cat "$STATE_FILE")
	DIFF=$(echo "$NOW - $LAST_PRESS" | bc)

	if (($(echo "$DIFF < $THRESHOLD" | bc -l))); then
		# Double tap detected!
		eval "$COMMAND"
		rm "$STATE_FILE"
		exit 0
	fi
fi

# Store current time for next press
echo "$NOW" >"$STATE_FILE"
