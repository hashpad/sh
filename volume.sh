#!/bin/bash
res=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
if [ "$1" == "up" ] && (("$res"<"100"));then
	pactl -- set-sink-volume 0 +1% && ~/scripts/update.sh vol
elif [ "$1" == "down" ] && (("$res">"0"));then
	pactl -- set-sink-volume 0 -1% && ~/scripts/update.sh vol
fi


