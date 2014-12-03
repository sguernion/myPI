#!/usr/bin/env python

import json
import urllib2
import ElemenTree as etree
#import base64
import ConfigParser

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/lua/config.properties')
server = config.get('', 'marantz.host');
port = config.get('', 'marantz.port');
#local caches


# Variables



def call_api(text):
	request = urllib2.Request('http://' + server + ':' + port + '/MainZone/index.put.asp?' + text)
	return urllib2.urlopen(request)
	
def change_source(source):
	return call_api('cmd0=PutZone_InputFunction%2F' + source )

def change_volume(decibel):
	return call_api('cmd0=PutMasterVolumeSet%2F' + decibel )

def volume_up():
	return call_api('cmd0=PutMasterVolumeBtn%2F%3E' )

def volume_down():
	return call_api('cmd0=PutMasterVolumeBtn%2F%3C' )

def get_state():
	tree = etree.parse('http://' + server + ':' + port + '/goform/formMainZone_MainZoneXml.xml?_=1412197835890' )
	entries = tree.xpath("//item/MasterVolume/value/text()")
	return urllib2.urlopen(request)

