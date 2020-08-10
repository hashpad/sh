#!/bin/bash
function myVolume {
	res=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
	if [ $res == 0 ];then
 	       echo -e "\uf026 $res%"
	elif (($res <= "50"));then
	       echo -e "\uf027 $res%"
        else
	       echo -e "\uf028 $res%"
	fi

}
function myDate {
	myDateStr="$(date +"%A, %d.%B - %H:%M")"
	echo -e "$myDateStr \uf017"
}


if [ "$1" == "init" ];then
	xsetroot -name "Welcome! (initializing stats...)"


elif [ "$1" == "vol" ];then

	xsetroot -name " [ Volume Set To  $(myVolume)  ] $(myDate)  "
else

function myMem {
	#myMemStr=`free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0}'`
	
	myMemStr=`free | awk '/Mem/ {printf "%d%%", $3 / $2 * 100}'`
	echo -e "RAM \uf538 $myMemStr"

}

function isConnectedToNet {
	if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
	       echo -e  "\uf1eb"
	else 
	       echo -e "NOT CONNECTED"
	fi
}
function myCPU {
	read cpu a b c previdle rest < /proc/stat
	prevtotal=$((a+b+c+previdle))
	sleep 0.5
	read cpu a b c idle rest < /proc/stat
	total=$((a+b+c+idle))
	cpu=$((100*((total-prevtotal)-(idle-previdle))/(total-prevtotal)))
	echo -e "CPU \uf2db $cpu%"
}
       xsetroot -name " [  $(myMem)  |  $(myCPU)  |  $(isConnectedToNet)  |  $(myVolume)  ] $(myDate)  "

 
fi
