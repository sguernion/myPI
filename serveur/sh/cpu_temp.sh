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
CPU_TEMP=`vcgencmd measure_temp |cut -c 6-9`
device_idx=$(read_properties $FILE_NAME "CPU_IDX")

url='http://192.168.0.17:8080/json.htm?'

replace=''
value=${CPU_TEMP//%/$replace}
json_command=$url'type=command&param=udevice&idx='$device_idx'&nvalue=0&svalue='$value
#echo $json_command
curl $json_command
