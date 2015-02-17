#!/bin/sh

source functions.sh

ip=$(read_properties $FILE_NAME "server.Ampli.ip")

curl http://$ip/MainZone/index.put.asp?cmd0=PutZone_InputFunction%2FDVD
 espeak "$1" -v fr+f3 -s 200 -p 40 2>/dev/null
