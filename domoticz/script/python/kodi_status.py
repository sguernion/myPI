#!/usr/bin/python
#   Title: kodi_status.py
#   Author: Chopper_Rob
#   Date: 27-10-2014
#   Info: Checks the state of Kodi and reports back to domoticz
#   URL : https://www.chopperrob.nl/domoticz/11-xbmc-kodi-status-in-domoticz
#   Version : 1.2
#
#   Changelog:
#   1.0 - Initial version
#   1.1 - Fixed high cpu load
#       - Basic Authentication support for domoticz
#   1.2 - Fixed authentication
#         Error 'local variable 'status' referenced before assignment' should be fixed
 
import socket, json, string, asynchat, asyncore, subprocess, sys, time, urllib2, datetime, base64
import os
import ConfigParser
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from kodi_api import *
from domoticz_api import *

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/config.properties')
 
# Domotizc switchid to toggle when Kodi machine comes online / offline
kodi_online = "P_Kodi"

# Interval between checks to see if Kodi is available in seconds
ping_interval = 10
 
 
# Do not change anything beyond this line.
#___________________________________________________________________________________________________
 
if int(subprocess.check_output('ps x | grep \'' + sys.argv[0] + '\' | grep -cv grep', shell=True)) > 2 :
    print datetime.datetime.now().strftime("%H:%M:%S") + "- script already running. exiting."
    sys.exit(0)
 

 
def domoticzstatus (switchid):
    status = ""
    state = get_state(switchid)
    if state == "On": 
         status = 1
    if state == "Off": 
         status = 0
    return status
 

previous_kodi_state = ""
previous_device_ping_state = -1
 
while 1==1:
    current_device_ping_state = subprocess.call('ping -q -c1 -W 1 '+ kodi_host + ' > /dev/null', shell=True)
    if current_device_ping_state == 0:  # 0 = online, 1 = offline
        if previous_device_ping_state != 0:
            print datetime.datetime.now().strftime("%H:%M:%S") + "- Kodi machine online"
            kodimachine = KODIClient(kodi_host, kodi_port)
            previous_kodi_state = ""
 
        if kodimachine.connection_state == "initialized" and previous_kodi_state != "initialized":
            print datetime.datetime.now().strftime("%H:%M:%S") + "- Trying to connect"
 
        if kodimachine.connection_state != "connected":
            try:
                kodimachine.connect((kodi_host, kodi_port))
            except Exception,e:
                print e
 
        if kodimachine.connection_state == "connected":
            if previous_kodi_state != "connected": 
                print datetime.datetime.now().strftime("%H:%M:%S") + "- Connected to Kodi"
                sendmessagetokodi(kodimachine, "Connection established")
            if domoticzstatus(kodi_online) == 0: set_state(kodi_online, 'On')
             
            print datetime.datetime.now().strftime("%H:%M:%S") + "- Sending request for player status"
            result = kodi_send(1,"Player.GetActivePlayers",'{}')
            json_data = json.dumps(result)
            json_data = json.loads(json_data)
            process_method(json_data.get("method", {}))
			
            if "result" in json_data:
                if len(json_data.get("result", {})) > 0:
                     process_result(json_data.get("result", {})[0])
                else:
				    set_state_idx (switchid_kodi_playing, 'Off')
            #asyncore.loop(timeout=5.0)
            #kodimachine = KODIClient(kodi_host, kodi_port)
    if current_device_ping_state == 1 and previous_device_ping_state != 1:
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Kodi machine offline"
        if domoticzstatus(kodi_online) == 1: set_state(kodi_online, 'Off')
 
    previous_device_ping_state = current_device_ping_state
    if current_device_ping_state == 0: previous_kodi_state = kodimachine.connection_state
    time.sleep (float(ping_interval))
    print "end while"