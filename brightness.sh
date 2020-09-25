#!/bin/bash

BRIGHTNESS=`xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '`

beforeNum="${BRIGHTNESS:0:1}"
beforeComma="${BRIGHTNESS:2:1}"


afterNum=$beforeNum
afterComma=$beforeComma

if [ "$1" == "up" ];then
	if [ $beforeNum == "0" ] && (($beforeComma < "9"));then
		afterNum="0"
		afterComma=$((beforeComma+1))

	
	elif [ $beforeNum == "0" ] && [ $beforeComma == "9" ];then
		afterNum="1"
		afterComma="0"		
	fi

elif [ "$1" == "down" ];then
	if [ $beforeNum == "0" ] && (( $beforeComma > "1" ));then
		afterNum="0"
		afterComma=$((beforeComma-1))


	elif [ $beforeNum == "0" ] && [ $beforeComma == "1" ];then
		afterNum="0"
		afterComma="0"		
	elif [ $beforeNum == "1" ];then
		afterNum="0"
		afterComma="9"
	fi
fi

xrandr --output eDP --brightness $afterNum.$afterComma
xrandr --output eDP-1 --brightness $afterNum.$afterComma
#echo $afterNum.$afterComma

