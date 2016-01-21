#!/usr/bin/env bash

FILE_NAME=/opt/domoticz-script/config.properties


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




# pourcentage memory used
CPU=`top -b -n 1 | grep "Cpu" | tail -n1 | awk '{print($2)}' | cut -d'%' -f 1`
device_idx=$(read_properties $FILE_NAME "CPU_USG_IDX")

url='http://192.168.0.17:8080/json.htm?'

replace=''
value=${CPU//%/$replace}
json_command=$url'type=command&param=udevice&idx='$device_idx'&nvalue='$value'&svalue='$value
#echo $json_command
curl $json_command
