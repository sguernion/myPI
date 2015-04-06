#!/usr/bin/env python

import json
import urllib2
#import base64
import ConfigParser


class DomoticzApi:

	def __init__(self):
		#config
		self.config = ConfigParser.RawConfigParser()
		self.config.read('/home/pi/domoticz/scripts/config.properties')
		
		
		# domoticz machine and port
		self.server = self.config.get('domoticz', 'domoticz.ip');
		self.port = self.config.get('domoticz', 'domoticz.port');
		self.password = self.config.get('domoticz', 'domoticz.pwd');
		self.username = self.config.get('domoticz', 'domoticz.user');
		self.debug = 1
		
		# Variables
		self.switch_map = {}
		self.scene_map = {}

	def get_switch_id(self,name_s):
		if len(self.switch_map) == 0:
			response = json.loads(self.call_api('type=command&param=getlightswitches'))
			for switch in response['result']:
				name = switch['Name']
				id = switch['idx']
				self.switch_map[name] = id
		if name_s in self.switch_map:
			print name_s + " " + self.switch_map[name_s]
			return self.switch_map[name_s]

	def get_scene_id(self,name_s):
		if len(self.scene_map) == 0:
			response = json.loads(self.call_api('type=scenes'))
			for scene in response['result']:
				name = scene['Name']
				id = scene['idx']
				self.scene_map[name] = id
		if name_s in self.scene_map:
			return self.scene_map[name_s]

	def call_api(self,text):
		return self.call_url('http://' + self.server + ':' + self.port + '/json.htm?' + str(text))
	
	def call_url(self,url):
		#print url
		request = urllib2.Request(url)
		#base64string = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
		#request.add_header("Authorization", "Basic %s" % base64string)   
		req= urllib2.urlopen(request)
		res = req.read()
		return res
	

	def get_state(self,name):
		idx = self.get_switch_id(name)
		if idx:
			return self.get_state_idx(idx)

	def get_state_idx(self,idx):
		response = json.loads(self.call_api('type=devices&rid=' + str(idx)))
		#print response
		item = response['result'][0]
		return item['Status']

	def set_state(self,name,state):
		idx = self.get_switch_id(name)
		if idx:
			self.set_state_idx(idx,state)
		else:
			print "Unknown switch name"
		
	def set_state_idx(self,idx,state):
		self.call_api('type=command&param=switchlight&idx=' + str(idx) + '&switchcmd=' + state)

	def set_udevice_state_idx(self,id,n_value,s_value):
		self.call_api('type=command&param=udevice&idx=' + str(id)+ '&nvalue=' + str(n_value) + '&svalue=' + str(s_value)  )

	def set_level(self,name,level):
		idx = self.get_switch_id(name)
		if idx:
			self.call_api('type=command&param=switchlight&idx=' + str(idx) + '&switchcmd=Set Level&level=' + str(level))
		else:
			print "Unknown switch name"

	def set_scene(self,name,state):
		idx = self.get_scene_id(name)
		if ok:
			self.call_api('type=command&param=switchscene&idx=' + str(idx) + '&switchcmd=' + state)
		else:
			print "Unknown scene name"
		
	def update_uservariable(self,name,value):
		configIdx = ConfigParser.RawConfigParser()
		configIdx.read('/home/pi/domoticz/scripts/domoticz.properties')
		idx_var = configIdx.get('variables', 'idx.'+name);
		type_var = configIdx.get('variables', 'type.'+name);
		self.call_api('type=command&param=updateuservariable&idx='+str(idx_var)+'&vname='+name+'&vtype='+str(type_var)+'&vvalue='+str(value))
	
	def debug(self):
		return self.debug
