#!/usr/bin/env python

import socket, json, string, asynchat, asyncore, subprocess, sys, urllib2, base64
import os
import ConfigParser
import subprocess
from datetime import date, time, datetime,timedelta

sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))

maintenant = datetime.now()
os.rename("/etc/lirc/lircrc","/etc/lirc/lircrc.save"+maintenant.strftime("%s"))

txt = open("/home/pi/domoticz/scripts/lirc_conf.json")
result = txt.read()
json_data = json.loads(result)

conf_file = open("/etc/lirc/lircrc", "w")

			
if "remotes" in json_data:
   if len(json_data["remotes"]) > 0:
      for remoteInfo in json_data["remotes"]:
          remote = remoteInfo["remote"]
          prefix = remoteInfo["device_prefix"]
          for receiveInfo in remoteInfo["receive"]:
             repeat = 1
             if 'repeat' in receiveInfo:
                 repeat = receiveInfo['repeat']
             conf_file.write("begin"+"\n")
             conf_file.write("    remote = "+remote+"\n")  
             print(remote+"."+str(receiveInfo["keys"]))
             for key in receiveInfo["keys"]:
                 conf_file.write("    button = "+key+"\n")
             conf_file.write("    prog = irexec"+"\n")
             if 'device' in receiveInfo:
                 conf_file.write("    config = python /home/pi/domoticz/scripts/python/domoticzCmd.py "+receiveInfo["device"]+" "+receiveInfo["cmd"]+"\n")
             if 'variable' in receiveInfo:
                 conf_file.write("    config = python /home/pi/domoticz/scripts/python/domoticzCmdVar.py "+receiveInfo["variable"]+" "+receiveInfo["cmd"]+"\n")
             conf_file.write("    repeat = "+str(repeat)+"\n")
             conf_file.write("end"+"\n\n\n")
   else:
      print 'ok'

conf_file.close()

subprocess.call(["/etc/init.d/lirc", "restart"])
