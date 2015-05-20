#!/usr/bin/env python

import time
import sys 
import os
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *
import ConfigParser

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/config.properties')

api = DomoticzApi()

def send_sms (user,key,message):
	api.call_url('https://smsapi.free-mobile.fr/sendmsg?user='+user+'&pass='+key+'&msg='+message)

	
user = config.get('global', 'free.mobile.api.user');
key = config.get('global', 'free.mobile.api.key');
departement="35"
idx_device_vigilance=8
idx_device_inondation=122

col=1
floodcol=1

color=api.call_url("http://api.domogeek.fr/vigilance/"+departement+"/color")
risk=api.call_url("http://api.domogeek.fr/vigilance/"+departement+"/risk")
flood=api.call_url("http://api.domogeek.fr/vigilance/"+departement+"/flood")

if color == "vert":
	col=1
elif color == "jaune":
	col=2
elif color == "orange":
	col=3
elif color == "rouge":
	col=4
	send_sms (user,key,'Vigilance : Attention risque Rouge')

if flood == "vert":
	floodcol=1
elif flood == "jaune":
	floodcol=2
elif flood == "orange":
	floodcol=3
elif flood == "rouge":
	floodcol=4
	send_sms (user,key,'Vigilance Innondation : Attention risque Rouge')

api.set_udevice_state_idx(idx_device_vigilance,col,risk);
api.set_udevice_state_idx(idx_device_inondation,floodcol,risk);
