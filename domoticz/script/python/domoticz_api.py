#!/usr/bin/env python

import json
import urllib2
#import base64
import ConfigParser

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/config.properties')

 
# domoticz machine and port
server = config.get('domoticz', 'domoticz.ip');
port = config.get('domoticz', 'domoticz.port');
password = config.get('domoticz', 'domoticz.pwd');
username = config.get('domoticz', 'domoticz.user');


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
	return call_url('http://' + server + ':' + port + '/json.htm?' + str(text))
	
def call_url(url):
	print url
	request = urllib2.Request(url)
	#base64string = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
	#request.add_header("Authorization", "Basic %s" % base64string)   
	req= urllib2.urlopen(request)
	res = req.read()
	return res
	

def get_state(name):
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

def set_udevice_state_idx(id,n_value,s_value):
	call_api('type=command&param=udevice&idx=' + str(id)+ '&nvalue=' + str(n_value) + '&svalue=' + str(s_value)  )

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
	