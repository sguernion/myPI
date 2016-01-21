#!/usr/bin/env python

import time
import sys 
import os
import json
import urllib2
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *



conf_file = open("/home/pi/domoticz/scripts/domoticz.properties", "w")
conf_file.write("[variables]"+"\n")

api = DomoticzApi()

response = json.loads(api.call_api('type=command&param=getuservariables'))


for userVar in response['result']:
	conf_file.write("# uservar "+userVar['Name']+"\n")
	conf_file.write("idx."+str(userVar['Name'])+"="+str(userVar['idx'])+"\n")
	conf_file.write("name."+str(userVar['Name'])+"="+str(userVar['Name'])+"\n")
	conf_file.write("type."+str(userVar['Name'])+"="+str(userVar['Type'])+"\n")

conf_file.write("[devices]"+"\n")

response = json.loads(api.call_api('type=devices&filter=all&used=true&order=Name'))

for switch in response['result']:
	conf_file.write("# Device "+switch['Name']+"\n")
	conf_file.write("idx."+str(switch['Name'])+"="+str(switch['idx'])+"\n")
	conf_file.write("name."+str(switch['Name'])+"="+str(switch['Name'])+"\n")
	conf_file.write("type."+str(switch['Name'])+"="+str(switch['Type'])+"\n")


#conf_file.write("[scenes]"+"\n")

#response = json.loads(api.call_api('type=scenes'))

#for scene in response['result']:
#	conf_file.write("# scene "+scene['Name']+"\n")
#	conf_file.write("idx."+str(scene['Name'])+"="+str(scene['idx'])+"\n")
#	conf_file.write("name."+str(scene['Name'])+"="+str(scene['Name'])+"\n")
	
#conf_file.close()