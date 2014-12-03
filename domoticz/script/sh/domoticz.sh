#!/bin/bash
################################################

command=$1
FILE_NAME=/home/pi/domoticz/scripts/lua/config.properties


read_properties()
{
  file="$1"
  prop="$2"
  while IFS="=" read -r key value; do
    case "$key" in
	  "$prop") echo "$value" ;;
    esac
  done < "$file"
}


url=$(read_properties $FILE_NAME "domoticz.url")
port=$(read_properties $FILE_NAME "domoticz.port")
idx_vol_mute=$(read_properties $FILE_NAME "idx.mute" )
idx_vol_up=$(read_properties $FILE_NAME "idx.vol.up")
idx_vol_down=$(read_properties $FILE_NAME "idx.vol.down")
idx_v_mute=$(read_properties $FILE_NAME "idx.v_mute")
idx_v_source=$(read_properties $FILE_NAME "idx.v_source")
idx_v_volume_up=$(read_properties $FILE_NAME "idx.v_volume.up")
idx_v_volume_down=$(read_properties $FILE_NAME "idx.v_volume.down")


case $command in
	volume_up)
	echo '$urltype=command&param=switchlight&idx='$idx_vol_up'&switchcmd=On'
	curl '$urltype=command&param=switchlight&idx='$idx_vol_up'&switchcmd=On'
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