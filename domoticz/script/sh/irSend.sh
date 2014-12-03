#!/bin/sh
#irSend.sh

command=$1

case $command in
	source)
	irsend SEND_ONCE lgtv input
	sleep 1
	irsend SEND_ONCE lgtv input
	sleep 1
	irsend SEND_ONCE lgtv KEY_OK
	sleep 1
	;;
	bfmtv)
	irsend SEND_ONCE lgtv KEY_1
	sleep 1
	irsend SEND_ONCE lgtv KEY_5
	sleep 1
	irsend SEND_ONCE lgtv KEY_OK
	sleep 1
	;;
	*)
		irsend SEND_ONCE lgtv $command
	;;
esac
 