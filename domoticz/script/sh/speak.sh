#!/bin/sh

curl http://192.168.0.11/MainZone/index.put.asp?cmd0=PutZone_InputFunction%2FDVD
sleep 7
mpg321 "http://translate.google.com/translate_tts?tl=fr&q=$1"