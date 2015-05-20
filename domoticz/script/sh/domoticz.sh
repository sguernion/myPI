#!/bin/bash
################################################
source  /home/pi/domoticz/scripts/sh/functions.sh
command=$1

domoticzIp=$(read_properties $FILE_NAME "domoticz.ip")
port=$(read_properties $FILE_NAME "domoticz.port")
idx_vol_mute=$(read_properties $IDX_FILE_NAME "idx.D_AMPLI_MUTE")
idx_vol_up=$(read_properties $IDX_FILE_NAME "idx.D_AMPLI_VUP")
idx_vol_down=$(read_properties $IDX_FILE_NAME "idx.D_AMPLI_VDOWN")
idx_v_mute=$(read_properties $IDX_FILE_NAME "idx.V_MUTE")
idx_v_source=$(read_properties $IDX_FILE_NAME "idx.V_SOURCE")
idx_v_volume_up=$(read_properties $IDX_FILE_NAME "idx.V_VOLUMEUP")
idx_v_volume_down=$(read_properties $IDX_FILE_NAME "idx.V_VOLUMEDOWN")

#url=$(read_properties $FILE_NAME "domoticz.url")
#echo $url
url='http://192.168.0.17:8080/json.htm?'

case $command in
	volume_up)
	commandUrl=$url'type=command&param=switchlight&idx='$idx_vol_up'&switchcmd=On'
	curl $commandUrl
	;;
	volume_down)
	curl $url'type=command&param=switchlight&idx='$idx_vol_down'&switchcmd=On'
	;;
	mute_on)
	curl $url'type=command&param=switchlight&idx='$idx_vol_mute'&switchcmd=On'
	;;
	# update variable
	source)
	curl $url'type=command&param=switchlight&idx='$idx_v_source'&switchcmd=On'
	;;
	v_volume_up)
	curl $url'type=command&param=switchlight&idx='$idx_v_volume_up'&switchcmd=On'
	;;
	v_volume_down)
	curl $url'type=command&param=switchlight&idx='$idx_v_volume_down'&switchcmd=On'
	;;
	v_mute_on)
	curl $url'type=command&param=switchlight&idx='$idx_v_mute'&switchcmd=On'
	;;
esac
