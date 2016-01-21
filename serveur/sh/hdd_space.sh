#!/usr/bin/env bash

HDD_DIR[0]="/"

HDD_IDX[0]=138


url='http://192.168.0.17:8080/json.htm?'
idx=0
for i in "${HDD_DIR[@]}"
do
	echo $i
	if [ $(mount | grep -c $i) == 0 ]
	then
		echo $i" not mounted "
	else
		VALUE_HDD=`df -P $i | tail -1 | awk '{print $5}'`
		replace=''
		value=${VALUE_HDD//%/$replace}
		json_command=$url'type=command&param=udevice&idx='${HDD_IDX[$idx]}'&nvalue='$value'&svalue='$value
		#echo $json_command
		curl $json_command
		idx=$(($idx+1))
	fi
done

