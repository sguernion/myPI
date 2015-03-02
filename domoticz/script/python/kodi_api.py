#!/usr/bin/env python

import socket, json, string, asynchat, asyncore, subprocess, sys, time, urllib2, datetime, base64
import ConfigParser
from urllib2 import urlopen
from json import loads

import os
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/config.properties')

 # Kodi machine and port
kodi_host = config.get('kodi', 'kodi.host');
kodi_port =  int(config.get('kodi', 'kodi.port'));
kodi_password = config.get('kodi', 'kodi.pw');
kodi_username = config.get('kodi', 'kodi.user');
kodi_image = config.get('kodi', 'kodi.notification.image');
kodi_title = config.get('kodi', 'kodi.notification.title');
kodi_time = config.get('kodi', 'kodi.notification.time');


switchid_kodi_playing = config.get('domoticz', 'idx.kodi_playing');

# Variables
debug = 1
ON ="On"
OFF ="Off"

###################################################
#
#        KODI functions
#
###################################################

def is_json(myjson):
  print myjson
  try:
    json_data = json.dumps(myjson)
    json_data = json.loads(json_data)
  except ValueError, e:
    print "is_json error" +e
    return False
  return True
  
def process_method(method):
    print method
    if method == "Player.OnPause": 
         if get_state_idx(switchid_kodi_playing) == ON : set_state_idx(switchid_kodi_playing,OFF) 
    if method == "Player.OnPlay": 
         if get_state_idx(switchid_kodi_playing) == OFF : set_state_idx(switchid_kodi_playing,ON) 
    if method == "Player.OnStop": 
         if get_state_idx(switchid_kodi_playing) == ON : set_state_idx(switchid_kodi_playing,OFF) 

def process_result(result):
    try:
        if "playerid" in result:
            if get_state_idx(switchid_kodi_playing) == OFF : set_state_idx (switchid_kodi_playing, ON)
    except Exception,e:
        print e

def getJson(url,username, password):
    base64string = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
    request = urllib2.Request(url)
    request.add_header("Authorization", "Basic %s" % base64string)   
    req = urlopen(request)
    res = req.read()
    data = loads(res)
    if debug == 1:
        print data
    return data

def kodi_request(request):
    rurl = 'http://'+ kodi_host +':'+str(kodi_port)+'/jsonrpc?request='+request
    if debug == 1:
        print rurl
    return getJson(rurl,kodi_password,kodi_username)

def kodi_send(id,method,params):
	return kodi_request('{"jsonrpc":"2.0","method":"' + method + '","params":' + params +',"id":'+ str(id) +'}')
 
def sendmessagetokodi(kodimachine, message):
    if kodimachine.connection_state == "connected":
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Sending Notification (" + message + ") to Kodi"
        request = '{"jsonrpc":"2.0","id":1,"method":"GUI.ShowNotification","params":{"title":"' + kodi_title + '","message":"' + message+ '","displaytime":' + kodi_time + ',"image":"' + kodi_image + '"}}';
        #kodimachine.send(request)
        kodi_request(request)

###################################################
#
#        KODI Client
#
###################################################
class KODIClient (asynchat.async_chat):
 
    def __init__(self, host, port):
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Preparing Kodi connection"
        asynchat.async_chat.__init__(self)
        self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
        self.set_terminator('\n')
        self.buffer = []
        self.received_data = []
        self.connection_state = "initialized"
 
    def collect_incoming_data(self, data):
        self.buffer.append(data)
        if is_json(data):
            json_data = json.dumps(myjson)
            json_data = json.loads(data)
            process_method(json_data.get("method", {}))
            if "result" in json_data:
			    process_result(json_data.get("result", {})[0])
             
 
    def found_terminator(self):
        msg = ''.join(self.buffer)
        if debug == 1:
             print 'Received : ', msg
        self.buffer = []
 
    def handle_connect_event(self):
        self.connection_state = "connected"
 
    def handle_connect(self):
        self.connection_state = "connected"
 
    def handle_close(self):
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Connection lost with Kodi"
        self.connection_state = "disconnected"
        self.close()
        return False
 
    def writable(self):
        return False