#!/bin/sh
################################################

command=$1
url='http://192.168.0.11/MainZone/index.put.asp?cmd0='

 #function getVolume {
	#curl -L http://192.168.0.11/goform/formMainZone_MainZoneXml.xml -o marantz.xml
	#v=80
	#volume=(( $v + $(xmlstarlet sel -t -v "item/MasterVolume/value/text()" marantz.xml)))
	#volume=30
	#return $volume
#}

case $command in
	volume_up)
	curl $url'PutMasterVolumeBtn%2F%3E'
	;;
	volume_down)
	curl $url'PutMasterVolumeBtn%2F%3C'
	;;
	source)
	curl $url'PutZone_InputFunction%2F'$2
	;;
	volume_set)
	curl $url'PutMasterVolumeSet%2F'$2
	;;
	volume)
	#echo getVolume()
	;;
	power_off)
	curl $url'PutZone_OnOff%2FOFF'
	;;
	power_on)
	curl $url'PutZone_OnOff%2FON'
	;;
	mute_off)
	curl $url'PutVolumeMute%2Foff'
	;;
	mute_on)
	curl $url'PutVolumeMute%2Fon'
	;;
esac