#!/bin/sh
################################################
# Settings
# --
#################################################
source functions.sh

message=$1




url=$(read_properties $FILE_NAME "kodi.url")
time=$(read_properties $FILE_NAME "kodi.notification.time")
image=$(read_properties $FILE_NAME "kodi.notification.image" )
title=$(read_properties $FILE_NAME "kodi.notification.title")


# XBMC
(wget -O /dev/null "$url?request={%22jsonrpc%22:%222.0%22,%22method%22:%22GUI.ShowNotification%22,%22params%22:{%22title%22:%22$title%22,%22message%22:%22$message%22,%22image%22:%22$image%22,%22displaytime%22:$time},%22id%22:1}" >/dev/null 2>&1) &
