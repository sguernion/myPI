#!/bin/bash

FILE_NAME=/home/pi/domoticz/scripts/config.properties
IDX_FILE_NAME=/home/pi/domoticz/scripts/domoticz.properties


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
