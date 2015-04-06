#!/usr/bin/env python

import json
import urllib2
#import xml.etree.ElemenTree as etree
#import base64
import ConfigParser


class MarantzApi:

	def __init__(self):
		#config
		self.config = ConfigParser.RawConfigParser()
		self.config.read('/home/pi/domoticz/scripts/config.properties')
		self.server = self.config.get('marantz', 'marantz.host');
		self.port = self.config.get('marantz', 'marantz.port');
		
		

	def call_api(self,text):
		request = urllib2.Request('http://' + self.server + ':' + self.port + '/MainZone/index.put.asp?' + text)
		return urllib2.urlopen(request)
	
	def change_source(self,source):
		return self.call_api('cmd0=PutZone_InputFunction%2F' + source )

	def change_volume(self,decibel):
		return self.call_api('cmd0=PutMasterVolumeSet%2F' + decibel )

	def volume_up(self):
		return self.call_api('cmd0=PutMasterVolumeBtn%2F%3E' )

	def volume_down(self):
		return self.call_api('cmd0=PutMasterVolumeBtn%2F%3C' )

	#def get_state(self):
	#	tree = etree.parse('http://' + self.server + ':' + self.port + '/goform/formMainZone_MainZoneXml.xml?_=1412197835890' )
	#	entries = tree.xpath("//item/MasterVolume/value/text()")
	#	return urllib2.urlopen(request)

