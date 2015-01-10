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
config.read('/home/pi/domoticz/scripts/lua/config.properties')

 
# Kodi machine and port
kodi_host = config.get('kodi', 'kodi.host');
kodi_port = int(config.get('kodi', 'kodi.port'));
 
# Domoticz server and port information
domoticzserver= config.get('domoticz', 'domoticz.ip')+":"+config.get('domoticz', 'domoticz.port')
domoticzusername = config.get('domoticz', 'domoticz.user');
domoticzpassword = config.get('domoticz', 'domoticz.pwd');
 
# Domotizc switchid to toggle when Kodi machine comes online / offline
kodi_online = "P_Kodi"
 
# Domoticz switchid to toggle when Kodi start playing / stops playing.
switchid_kodi_playing = 62
 
# Title for nofications to Kodi (empty disables notification)
message_title = "Kodi Status Script"
 
# Interval between checks to see if Kodi is available in seconds
ping_interval = 1
 
 
# Do not change anything beyond this line.
#___________________________________________________________________________________________________
 
if int(subprocess.check_output('ps x | grep \'' + sys.argv[0] + '\' | grep -cv grep', shell=True)) > 2 :
    print datetime.datetime.now().strftime("%H:%M:%S") + "- script already running. exiting."
    sys.exit(0)
 

 
def domoticzstatus (switchid):
    status = ""
    state = get_state_idx(switchid)
    if state == "On": 
         status = 1
    if state == "Off": 
         status = 0
    return status


def process_method(method):
    if method == "Player.OnPause": set_state_idx(switchid_kodi_playing,'Off') 
    if method == "Player.OnPlay": set_state_idx(switchid_kodi_playing,'On') 
    if method == "Player.OnStop": set_state_idx(switchid_kodi_playing,'Off') 

 

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
                if message_title: sendmessagetokodi(kodimachine,message_title, "Connection established")
            set_state_idx(switchid_kodi_online, 'On')
             
            print datetime.datetime.now().strftime("%H:%M:%S") + "- Sending request for player status"
            kodimachine.send ('{"jsonrpc": "2.0", "method": "Player.GetActivePlayers", "id": 1}')
 
            asyncore.loop(timeout=5.0)
            #kodimachine = KODIClient(kodi_host, kodi_port)
    if current_device_ping_state == 1 and previous_device_ping_state != 1:
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Kodi machine offline"
        if domoticzstatus(switchid_kodi_online) == 1: set_state(kodi_online, 'Off')
 
    previous_device_ping_state = current_device_ping_state
    if current_device_ping_state == 0: previous_kodi_state = kodimachine.connection_state
    time.sleep (float(ping_interval))