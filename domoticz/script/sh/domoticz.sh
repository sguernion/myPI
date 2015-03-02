#!/bin/bash
################################################

command=$1

FILE_NAME=/home/pi/domoticz/scripts/config.properties

read_properties()
{
  file="$1"
  while IFS="=" read -r key value; do
    case "$key" in
      "domoticz.ip") domoticzIp="$value" ;;
      "domoticz.port") port="$value" ;;
	  "idx.mute") idx_vol_mute="$value" ;;
	  "idx.vol.up") idx_vol_up="$value" ;;
	  "idx.vol.down") idx_vol_down="$value" ;;
	  "idx.v_mute") idx_v_mute="$value" ;;
	  "idx.v_source") idx_v_source="$value" ;;
	  "idx.v_volume.up") idx_v_volume_up="$value" ;;
	  "idx.v_volume.down") idx_v_volume_down="$value" ;;
    esac
  done < "$file"
}

read_properties $FILE_NAME

url='http://192.168.0.17:8080/json.htm?'


case $command in
	volume_up)
	curl $url'type=command&param=switchlight&idx='$idx_vol_up'&switchcmd=On'
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