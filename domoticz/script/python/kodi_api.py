#!/usr/bin/env python

import socket, json, string, asynchat, asyncore, subprocess, sys, time, urllib2, datetime, base64
import ConfigParser

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/lua/config.properties')

 # Kodi machine and port
kodi_host = config.get('kodi', 'kodi.host');
kodi_port = config.get('kodi', 'kodi.port');

#local caches


# Variables


def is_json(myjson):
  try:
    json_object = json.loads(myjson)
  except ValueError, e:
    return False
  return True
 
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
            json_data = json.loads(data)
            process_method(json_data.get("method", {}))
            if "result" in json_data:
                try:
                    if "playerid" in json_data.get("result", {})[0]:
                        setdomoticzstatus (self,switchid_kodi_playing, True)
                except Exception,e:
                    print e
 
    def found_terminator(self):
        msg = ''.join(self.buffer)
        print 'Received : ', msg
        print
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
 
 
def sendmessagetokodi(kodimachine,title, message):
    if kodimachine.connection_state == "connected":
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Sending Notification (" + message + ") to Kodi"
        kodimachine.send('{"jsonrpc":"2.0","id":1,"method":"GUI.ShowNotification","params":{"title":"' + title + '","message":"' + message+ '"}}')
