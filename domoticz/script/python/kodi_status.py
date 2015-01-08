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
 
import ConfigParser

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/lua/config.properties')

 
# Kodi machine and port
kodi_host = config.get('kodi', 'kodi.host');
kodi_port = config.get('kodi', 'kodi.port');
 
# Domoticz server and port information
domoticzserver= config.get('domoticz', 'domoticz.ip')+":"+config.get('domoticz', 'domoticz.port')
domoticzusername = config.get('domoticz', 'domoticz.user');
domoticzpassword = config.get('domoticz', 'domoticz.pwd');
 
# Domotizc switchid to toggle when Kodi machine comes online / offline
switchid_kodi_online = "10"
 
# Domoticz switchid to toggle when Kodi start playing / stops playing.
switchid_kodi_playing = "53"
 
# Title for nofications to Kodi (empty disables notification)
message_title = "Kodi Status Script"
 
# Interval between checks to see if Kodi is available in seconds
ping_interval = 1
 
 
# Do not change anything beyond this line.
#___________________________________________________________________________________________________
 
if int(subprocess.check_output('ps x | grep \'' + sys.argv[0] + '\' | grep -cv grep', shell=True)) > 2 :
    print datetime.datetime.now().strftime("%H:%M:%S") + "- script already running. exiting."
    sys.exit(0)
 
def is_json(myjson):
  try:
    json_object = json.loads(myjson)
  except ValueError, e:
    return False
  return True
 
 
def sendmessagetokodi(title, message):
    if kodimachine.connection_state == "connected":
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Sending Notification (" + message + ") to Kodi"
        kodimachine.send('{"jsonrpc":"2.0","id":1,"method":"GUI.ShowNotification","params":{"title":"' + title + '","message":"' + message+ '"}}')
 
def domoticzstatus (switchid):
    status = ""
    json_object = json.loads(domoticzrequest(domoticzurl))
 
    if json_object["status"] == "OK":
        for i, v in enumerate(json_object["result"]):
            if json_object["result"][i]["idx"] == switchid and "Lighting" in json_object["result"][i]["Type"] :
                if json_object["result"][i]["Status"] == "On": 
                    status = 1
                if json_object["result"][i]["Status"] == "Off": 
                    status = 0
    return status
 
def domoticzrequest (url):
  request = urllib2.Request(url)
  base64string = base64.encodestring('%s:%s' % (domoticzusername, domoticzpassword)).replace('\n', '')
  request.add_header("Authorization", "Basic %s" % base64string)
  response = urllib2.urlopen(request)
  return response.read()
 
def setdomoticzstatus (switchid, switchstatus):
    tempstatus = domoticzstatus(switchid)
    if switchstatus == True and tempstatus == 0:
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Tell Domoticz switchid " + switchid + " is On"
        domoticzrequest("http://" + domoticzserver + "/json.htm?type=command&param=switchlight&idx=" + switchid + "&switchcmd=On&level=0")
    if switchstatus == True and tempstatus == 1:
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Wanted to tell Domoticz switchid " + switchid + " is On, but he already knows."
    if switchstatus == False and tempstatus == 1:
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Tell Domoticz switchid " + switchid + " is Off"
        domoticzrequest("http://" + domoticzserver + "/json.htm?type=command&param=switchlight&idx=" + switchid + "&switchcmd=Off&level=0")
    if switchstatus == False and tempstatus == 0:
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Wanted to tell Domoticz switchid " + switchid + " is Off, but he already knows."
 
def process_method(method):
    if method == "Player.OnPause": setdomoticzstatus(switchid_kodi_playing, False)
    if method == "Player.OnPlay": setdomoticzstatus(switchid_kodi_playing, True)
    if method == "Player.OnStop": setdomoticzstatus(switchid_kodi_playing, False)
 
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
                        setdomoticzstatus (switchid_kodi_playing, True)
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
 
 
domoticzurl = 'http://'+domoticzserver+'/json.htm?type=devices&filter=all&used=true&order=Name'
 
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
                if message_title: sendmessagetokodi(message_title, "Connection established")
            setdomoticzstatus(switchid_kodi_online, True)
             
            print datetime.datetime.now().strftime("%H:%M:%S") + "- Sending request for player status"
            kodimachine.send ('{"jsonrpc": "2.0", "method": "Player.GetActivePlayers", "id": 1}')
 
            asyncore.loop(timeout=5.0)
            #kodimachine = KODIClient(kodi_host, kodi_port)
    if current_device_ping_state == 1 and previous_device_ping_state != 1:
        print datetime.datetime.now().strftime("%H:%M:%S") + "- Kodi machine offline"
        if domoticzstatus(switchid_kodi_online) == 1: setdomoticzstatus(switchid_kodi_online, False)
 
    previous_device_ping_state = current_device_ping_state
    if current_device_ping_state == 0: previous_kodi_state = kodimachine.connection_state
    time.sleep (float(ping_interval))