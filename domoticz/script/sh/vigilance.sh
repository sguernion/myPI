#!/bin/sh
#vigilance.sh
color=$(curl http://api.domogeek.fr/vigilance/35/color)
risk=$(curl http://api.domogeek.fr/vigilance/35/risk)
if [ $color = "vert" ]; then
col=1
elif [ $color = "jaune" ]; then
col=2
elif [ $color = "orange" ]; then
col=3
elif [ $color = "rouge" ]; then
col=4

# TODO Send SMS
fi
curl http://192.168.0.17:8080/json.htm?type=command\&param=udevice\&idx=8\&nvalue=$col\&svalue="$risk"