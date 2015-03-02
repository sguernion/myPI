#!/bin/bash
source functions.sh
ampliIp=$(read_properties $FILE_NAME "server.Ampli.ip")


url='http://'$ampliIp'/MainZone/index.put.asp?cmd0='

curl url'PutZone_InputFunction%2FDVD'
sleep 7
mpg321 "http://translate.google.com/translate_tts?tl=fr&q=$1"