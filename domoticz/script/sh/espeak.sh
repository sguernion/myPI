#!/bin/sh

curl http://192.168.0.11/MainZone/index.put.asp?cmd0=PutZone_InputFunction%2FDVD
 espeak "$1" -v fr+f3 -s 200 -p 40 2>/dev/null
