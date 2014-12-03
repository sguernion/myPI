#!/usr/bin/env python
from urllib2 import urlopen
from json import loads
from time import time
import socket, json, string, sys, urllib2, datetime, base64
 
import ConfigParser

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/lua/config.properties')

 
# Kodi machine and port
kodi_host = config.get('', 'kodi.host');
kodi_port = config.get('', 'kodi.port');
kodi_password = config.get('', 'kodi.pw');
kodi_username = config.get('', 'kodi.user');
 
# Domoticz server and port information
domoticzserver= config.get('', 'domoticz.ip')+":"+config.get('', 'domoticz.port')
domoticzusername = config.get('', 'domoticz.user');
domoticzpassword = config.get('', 'domoticz.pwd');

# Domoticz uservariable
uservarid_kodi_play_duration = "13"
kodi_play_duration = "kodi_play_duration"
kodi_play_duration_type = 2

# Do not change anything beyond this line.
#___________________________________________________________________________________________________

def getJson(url,username, password):
     base64string = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
     request = urllib2.Request(url)
     request.add_header("Authorization", "Basic %s" % base64string)   
     req = urlopen(request)
     res = req.read()
     data = loads(res)
     return data
	 
def kodi_send(request):
     return getJson('http://'+ kodi_host +':'+str(kodi_port)+'/jsonrpc?request='+request,kodi_password,kodi_username)
	 
def domoticz_update_uservariable(id,name,type,value):
     dz_url = 'http://'+domoticzserver+'/json.htm?type=command&param=updateuservariable&idx='+id+'&vname='+name+'&vtype='+type+'&vvalue=0'+value
     #print(dz_url)
     getJson(dz_url,domoticzusername, domoticzpassword)
	 
response = kodi_send('{"id":1,"jsonrpc":"2.0","method":"Player.GetProperties","params":{"playerid":1,"properties":["totaltime","percentage","time"]}}')
t_time = (((response['result']['totaltime']['hours']*60+response['result']['totaltime']['minutes']))*60)+response['result']['totaltime']['seconds']
p_time = (((response['result']['time']['hours']*60+response['result']['time']['minutes']))*60)+response['result']['time']['seconds']
r_time = t_time - p_time

duration = str(datetime.timedelta(seconds=r_time))
print(duration)


domoticz_update_uservariable(uservarid_kodi_play_duration,kodi_play_duration,kodi_play_duration_type,duration[0:-3])
