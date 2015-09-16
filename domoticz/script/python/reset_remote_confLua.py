#!/usr/bin/env python

import socket, json, string, asynchat, asyncore, subprocess, sys, urllib2, base64
import os
import ConfigParser
import subprocess
from datetime import date, time, datetime,timedelta
from domoticz_api import *


sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
api = DomoticzApi()

def createDeviceIfNotExist(name):
    config = ConfigParser.RawConfigParser()
    config.read('/home/pi/domoticz/scripts/domoticz.properties')
    try:
       idx= config.get('devices', 'idx.'+name);
       #print(" device exist "+name)
    except ConfigParser.NoOptionError, err:
       print(" create Device "+name)
       sensortype = 6
       materialIdx = 3
       switchtype = 9
       api.createVirtualDevice(materialIdx,sensortype,name,switchtype)


txt = open("/home/pi/domoticz/scripts/lirc_conf.json")
result = txt.read()
json_data = json.loads(result)



if "remotes" in json_data:
   if len(json_data["remotes"]) > 0:
      for remoteInfo in json_data["remotes"]:
          remote = remoteInfo["remote"] 
          override = remoteInfo["override"]
          prefix = remoteInfo["device_prefix"]
          if(override == "true"):
             if len(remoteInfo["send"]) > 0:
                 conf_file = open("/home/pi/domoticz/scripts/lua/script_device_remote_"+remote+".lua", "w")
                 conf_file.write("-- generated script file"+"\n\n")
                 conf_file.write("commandArray = {}"+"\n\n")
                 conf_file.write("package.path = package.path..\";/home/pi/domoticz/scripts/lua/modules/?.lua\""+"\n")
                 conf_file.write("require 'functions_utils'"+"\n")
                 conf_file.write("require 'functions_custom'"+"\n\n\n")
                 for receiveInfo in remoteInfo["send"]:
                    device = receiveInfo["device"]
                    #create device ifnot exist
                    createDeviceIfNotExist(prefix+device)
                    cmd = "On"
                    conf_file.write("if ( devicechanged['"+prefix+device+"'] == '"+cmd+"' ) then"+"\n")
                    #print(remote+"."+str(receiveInfo["keys"]))
                    for key in receiveInfo["keys"]:
                        conf_file.write("	irsend('"+remote+"','"+key+"')\n")
                    conf_file.write("end"+"\n\n\n")
                 conf_file.write("return commandArray"+"\n")
   else:
      print 'ok'

conf_file.close()



