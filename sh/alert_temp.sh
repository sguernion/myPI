#!/bin/bash
TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
if [ $TEMP -ge 30 ] ; then
gpio -g write 18 1
sleep 5
gpio -g write 18 0
fi