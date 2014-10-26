#!/bin/sh
################################################
# Settings
user="xbmc"
pw="xbmc"
port="80"
host="192.168.0.10"
time=15000
#################################################

command=$1
url="http://$user:$pw@$host:$port/jsonrpc"

#http://$user:$pw@$host:$port/jsonrpc

callxbmc () { 
   curl -i -X POST -H "Content-Type: application/json" -d '$1' $2
}

case $command in
	up)
		callxbmc '{"jsonrpc": "2.0", "method": "Input.Up", "params": {  }, "id": 1 }' $url
	;;
	down)
		callxbmc '{"jsonrpc": "2.0", "method": "Input.Down", "params": {  }, "id": 1 }' $url
	;;
	left)
		callxbmc '{"jsonrpc": "2.0", "method": "Input.Left", "params": {  }, "id": 1 }' $url
	;;
	right)
		callxbmc '{"jsonrpc": "2.0", "method": "Input.Right", "params": {  }, "id": 1 }' $url
	;;
	ok)
		callxbmc '{"jsonrpc":"2.0","method":"Input.Select","params": {},"id":1}' $url
	;;
	back)
		callxbmc '{"jsonrpc":"2.0","method":"Input.Back","params":{},"id":1}' $url
	;;
	play)
		callxbmc '{"jsonrpc":"2.0","method":"Player.PlayPause","params":{"playerid":0},"id":1}' $url
	;;
	stop_player)
		callxbmc '{"jsonrpc":"2.0","method":"Player.Stop","params":{"playerid":0},"id":1}' $url
	;;
	shutdown)
		callxbmc '{"jsonrpc": "2.0", "method": "System.Shutdown", "params": {  }, "id": 1 }' $url
	;;
	subtitle)
		callxbmc '{"jsonrpc": "2.0", "method": "Player.SetSubtitle", "params": {  }, "id": 1 }' $url
	;;
	party)
		callxbmc '{ "jsonrpc": "2.0", "method": "Player.Open", "params": { "item": { "partymode": "music" } }, "id": 1 }' $url
	;;
esac