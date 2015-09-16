#!/bin/bash

#irSend.sh

source functions.sh

remote=$1
command=$2
case $remote in
	lgtv)
		irsend SEND_ONCE lgtv $command
	;;
	led)
		irsend SEND_ONCE led $command
	;;
	*)
	;;
esac

