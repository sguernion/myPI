#!/usr/bin/env python

import json
import urllib2
#import base64
 
import ConfigParser

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/lua/config.properties')

 
# domoticz machine and port
server = config.get('domoticz', 'domoticz.ip');
port = config.get('domoticz', 'domoticz.port');
password = config.get('domoticz', 'domoticz.pwd');
username = config.get('domoticz', 'domoticz.user');



#local caches
state_cache_dir = "/home/pi/domoticz/state/"
cached_states = {'day','away','daylight'}

# Variables
switch_map = {}
scene_map = {}

def get_switch_id(name_s):
	if len(switch_map) == 0:
		response = json.load(call_api('type=command&param=getlightswitches'))
		for switch in response['result']:
			name = switch['Name']
			id = switch['idx']
			switch_map[name] = id
	if name_s in switch_map:
		print name_s + " " + switch_map[name_s]
		return switch_map[name_s]

def get_scene_id(name_s):
	if len(scene_map) == 0:
		response = json.load(call_api('type=scenes'))
		for scene in response['result']:
			name = scene['Name']
			id = scene['idx']
			scene_map[name] = id
	if name_s in scene_map:
		return scene_map[name_s]

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
		
	idx = get_switch_id(name)
	if idx:
		return get_state_idx(idx)

def get_state_idx(idx):
	response = json.load(call_api('type=devices&rid=' + str(idx)))
	#print response
	item = response['result'][0]
	return item['Status']

def set_state(name,state):
	idx = get_switch_id(name)
	if idx:
		set_state_idx(idx,state)
	else:
		print "Unknown switch name"
		
def set_state_idx(idx,state):
	call_api('type=command&param=switchlight&idx=' + str(idx) + '&switchcmd=' + state)


def set_level(name,level):
	idx = get_switch_id(name)
	if idx:
		call_api('type=command&param=switchlight&idx=' + str(idx) + '&switchcmd=Set Level&level=' + str(level))
	else:
		print "Unknown switch name"

def set_scene(name,state):
	idx = get_scene_id(name)
	if ok:
		call_api('type=command&param=switchscene&idx=' + str(idx) + '&switchcmd=' + state)
	else:
		print "Unknown scene name"
		
def update_uservariable(id,name,type,value):
	 call_api('type=command&param=updateuservariable&idx='+str(id)+'&vname='+name+'&vtype='+str(type)+'&vvalue='+str(value))
	