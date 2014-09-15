#!/bin/sh
################################################
# Settings
title=$1
message=$2
image=$3
user="user"
pw="password"
port="80"
host="192.168.0.10"
time=15000
#################################################
# XBMC
(wget -O /dev/null "http://$user:$pw@$host:$port/jsonrpc?request={%22jsonrpc%22:%222.0%22,%22method%22:%22GUI.ShowNotification%22,%22params%22:{%22title%22:%22$title%22,%22message%22:%22$message%22,%22image%22:%22$image%22,%22displaytime%22:$time},%22id%22:1}" >/dev/null 2>&1) &
