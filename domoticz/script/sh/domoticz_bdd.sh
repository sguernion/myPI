#! /bin/bash

source  /home/pi/domoticz/scripts/sh/functions.sh

taille=$(ls -lisa /home/pi/domoticz/domoticz.db|cut -d' ' -f7)

domoticzIp=$(read_properties $FILE_NAME "domoticz.ip")
port=$(read_properties $FILE_NAME "domoticz.port")

idx_v_bdd_size=$(read_properties $IDX_FILE_NAME "idx.bdd_size")
name_v_bdd_size=$(read_properties $IDX_FILE_NAME "name.bdd_size")
type_v_bdd_size=$(read_properties $IDX_FILE_NAME "type.bdd_size")

#url=$(read_properties $FILE_NAME "domoticz.url")
url='http://192.168.0.17:8080/json.htm?'

json_command=$url'type=command&param=updateuservariable&idx='$idx_v_bdd_size'&vname='$name_v_bdd_size'&vtype='$type_v_bdd_size'&vvalue='$taille
echo $json_command
curl $json_command