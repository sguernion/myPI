#!/usr/bin/env python
import jsonrpclib
import json

server = jsonrpclib.Server('http://192.168.0.10/jsonrpc')

def is_playing_video():
	active_players = server.Player.GetActivePlayers()
	print jsonrpclib.history.response
        properties = ['speed']
        for player in active_players:
                if player['playerid'] == 1:
                        property = server.Player.GetProperties(1,['speed'])
			print jsonrpclib.history.response
                        if property['speed'] == 1:
				return True
			else:
				return False
 
def pause():
	if is_playing_video():
		try:
			server.Player.PlayPause(1)
		except:
			print "Pause failed"
		#print jsonrpclib.history.response

def show_message(title, message):
	server.GUI.ShowNotification(title, message)
	#print jsonrpclib.history.response

def play_channel(channel_id):
	server.Player.Open({'channelid':1})
	#print jsonrpclib.history.response
	
def stop():
	if is_playing_video():
		server.Player.Stop(1)
		print jsonrpclib.history.response