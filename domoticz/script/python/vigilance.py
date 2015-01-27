#!/usr/bin/env python

import time
import sys 
import os
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *
import ConfigParser

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/lua/config.properties')

def send_sms (user,key,message):
	call_url('https://smsapi.free-mobile.fr/sendmsg?user='+user+'&pass='+key+'&msg='+message)

	
user = config.get('global', 'free.mobile.api.user');
key = config.get('global', 'free.mobile.api.key');

col=1

color=call_url("http://api.domogeek.fr/vigilance/35/color")
risk=call_url("http://api.domogeek.fr/vigilance/35/risk")

if color == "vert":
	col=1
elif color == "jaune":
	col=2
elif color == "orange":
	col=3
elif color == "rouge":
	col=4
	send_sms (user,key,'Vigilance : Attention risque Rouge')


set_udevice_state_idx(8,col,risk);