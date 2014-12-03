#!/bin/bash
################################################
# Settings
time=15000
#################################################

command=$1
FILE_NAME=/home/pi/domoticz/scripts/lua/config.properties

read_properties()
{
  file="$1"
  while IFS="=" read -r key value; do
		case "$key" in
		  "kodi.url") echo "$value" ;;
		esac
  done < "$file"
}

url=$(read_properties $FILE_NAME)


#url=http://$user:$pw@$host:$port/jsonrpc

case $command in
	up)
	curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0", "method": "Input.Up", "params": {  }, "id": 1 }' $url
	;;
	down)
	curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0", "method": "Input.Down", "params": {  }, "id": 1 }' $url
	;;
	left)
	curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0", "method": "Input.Left", "params": {  }, "id": 1 }' $url
	;;
	right)
	curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0", "method": "Input.Right", "params": {  }, "id": 1 }' $url
	;;
	ok)
	curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"Input.Select","params": {},"id":1}' $url
	;;
	back)
	curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"Input.Back","params":{},"id":1}' $url
	;;
	play)
	curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"Player.PlayPause","params":{"playerid":0},"id":1}' $url
	
	;;
	stop_player)
	curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"Player.Stop","params":{"playerid":0},"id":1}' $url
	;;
	shutdown)
	curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0", "method": "System.Shutdown", "params": {  }, "id": 1 }' $url
	;;
	subtitle)
	curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0", "method": "Player.SetSubtitle", "params": {  }, "id": 1 }' $url
	;;
	party)
	curl -i -X POST -H "Content-Type: application/json" -d '{ "jsonrpc": "2.0", "method": "Player.Open", "params": { "item": { "partymode": "music" } }, "id": 1 }' $url
	;;
esac