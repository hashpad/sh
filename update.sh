#!/bin/bash
function weather {
    LOCATION=karlsruhe
    printf "%s"
    if [ "$IDENTIFIER" = "unicode" ]; then
        printf "%s" "$(curl -s wttr.in/$LOCATION?format=1)"
    else
        printf "\uf76b %s" "$(curl -s wttr.in/$LOCATION?format=1 | grep -o "[+|-][0-9].*")"
    fi
    printf "%s\n"
}
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
	myDateStr="$(date +"%a, %d.%b - %H:%M")"
	echo -e "$myDateStr"
}


if [ "$1" == "init" ];then
	xsetroot -name "Welcome! (initializing stats...)"


elif [ "$1" == "vol" ];then

	xsetroot -name " [ Volume Set To  $(myVolume)  ] $(myDate)  "
else

function myMem {
	#myMemStr=`free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0}'`
	
	myMemStr=`free | awk '/Mem/ {printf "%d%%", $3 / $2 * 100}'`
	echo -e "\uf538 $myMemStr"

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
	echo -e "\uf2db $cpu%"
}

function myBattery {
    acpi=`acpi`
    if [ "${acpi:11:1}" == "C" ];then
        if [ "${acpi:23:1}" == "0" ];then
            percentage="100"
            remaining=""
        else
            percentage="${acpi:21:2}"
            remaining="${acpi:26:5}"
        fi
        icon="\uf1e6"
        if (( "$percentage" >= "99" ));then
            percentage="100"
            remaining=""
        fi
    fi   
    if [ "${acpi:11:1}" == "D" ];then
        if [ "${acpi:26:1}" == "0" ];then
            percentage="100"
            remaining="${acpi:30:5}"
        else
            percentage="${acpi:24:2}"
            remaining="${acpi:29:5}"
        fi
        if (( "$percentage" >= "90" ));then
            icon="\uf240"
        elif (( "$percentage" >= "75" ));then
            icon="\uf241"
        elif (( "$percentage" >= "50" ));then
            icon="\uf242"

        elif (( "$percentage" >= "20" ));then
            icon="\uf243"
        elif (( "$percentage" >= "5" ));then
            icon="\uf244"
        else
            STATUS=$(cmus-remote -Q | grep -a '^status' | awk '{gsub("status ", "");print}')

            if [ "$STATUS" = "playing" ]; then
                cmus-remote -u
            fi
            
            systemctl hibernate
        fi
    fi
    if [ "${acpi:11:1}" == "F" ];then
        percentage="100"
        remaining=""
        icon="\uf240"
    fi
    percentage="${percentage//%}"
    if [ "${remaining:0:1}" == "d" ];then
        remaining="calc..."
    fi
    if (( "$percentage" <= "9" )) && [ "${acpi:11:1}" == "D" ];then
        remaining="${acpi:28:5}"
    fi

    if (( "$percentage" <= "9" )) && [ "${acpi:11:1}" == "C" ];then
        remaining="${acpi:25:5}"
    fi
    echo -e "$icon $percentage%~$remaining" 
}


dwm_cmus () {
    if ps -C cmus > /dev/null; then
        ARTIST=$(cmus-remote -Q | grep -a '^tag artist' | awk '{gsub("tag artist ", "");print}')
        TRACK=$(cmus-remote -Q | grep -a '^tag title' | awk '{gsub("tag title ", "");print}')
        POSITION=$(cmus-remote -Q | grep -a '^position' | awk '{gsub("position ", "");print}')
        DURATION=$(cmus-remote -Q | grep -a '^duration' | awk '{gsub("duration ", "");print}')
        STATUS=$(cmus-remote -Q | grep -a '^status' | awk '{gsub("status ", "");print}')
        SHUFFLE=$(cmus-remote -Q | grep -a '^set shuffle' | awk '{gsub("set shuffle ", "");print}')

            if [ "$STATUS" = "playing" ]; then
                STATUS="\uf04b"
            else
                STATUS="\uf04c"
            fi

            if [ "$SHUFFLE" = "true" ]; then
                SHUFFLE="\uf074"
            else
                SHUFFLE=""
            fi
        printf "$ARTIST $TRACK "
        printf "(%0d:%02d/" $((POSITION%3600/60)) $((POSITION%60))
        printf "%0d:%02d" $((DURATION%3600/60)) $((DURATION%60))
        echo -e ") $SHUFFLE$STATUS"
    fi
}

    xsetroot -name "[$(dwm_cmus) | $(weather)] [$(myMem)|$(myCPU)|$(isConnectedToNet)|$(myVolume)][$(myBattery)] $(myDate) "
       

 
fi
