#!/usr/bin/env python

import json
import urllib2
#import base64

#config
server = '192.168.0.17'
port = '8080'

#local caches
state_cache_dir = "/home/pi/domoticz/state/"
cached_states = {'day','away','daylight'}

# Variables
switch_map = None
scene_map = None

def get_switch_id(name):
	if switch_map is None:
		response = json.load(call_api('type=command&param=getlightswitches'))
		for switch in response.result:
			name = lower(switch.Name)
			id = switch.idx
			switch_map[name] = id
	if name in switch_map:
		return switch_map[name]

def get_scene_id(name):
	if scene_map is  None:
		response = json.load(call_api('type=scenes'))
		for scene in response.result:
			name = lower(scene.Name)
			id = scene.idx
			scene_map[name] = id
	if name in scene_map:
		return scene_map[name]

def call_api(text):
	request = urllib2.Request('http://' + server + ':' + port + '/json.htm?' + text)
	#base64string = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
	#request.add_header("Authorization", "Basic %s" % base64string)   
	return urllib2.urlopen(request)
	
def get_cached_state(name):
	file = open(state_cache_dir + name, "r")
	state = df.read()
	print "Cached state is: " + state
	return state

def get_state(name):
	if name in cached_states:
		return get_cached_state(name)
		
	ok, idx = get_switch_id(name)
	if ok:
		return get_state_idx(idx)

def get_state_idx(idx):
	response = json.load(call_api('type=devices&rid=' + str(idx)))
	#print response
	item = response['result'][0]
	return item['Status']

def set_state(name,state):
	ok, idx = get_switch_id(name)
	if ok:
		set_state_idx(idx,state)
	else:
		print "Unknown switch name"
		
def set_state_idx(idx,state):
	call_api('type=command&param=switchlight&idx=' + str(idx) + '&switchcmd=' + state)


def set_level(name,level):
	ok, idx = get_switch_id(name)
	if ok:
		call_api('type=command&param=switchlight&idx=' + str(idx) + '&switchcmd=Set Level&level=' + str(level))
	else:
		print "Unknown switch name"

def set_scene(name,state):
	ok, idx = get_scene_id(name)
	if ok:
		call_api('type=command&param=switchscene&idx=' + str(idx) + '&switchcmd=' + state)
	else:
		print "Unknown scene name"