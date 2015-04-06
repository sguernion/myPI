#!/usr/bin/env python

import time
import sys 
import os
import json
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *
import ConfigParser

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/config.properties')

ville=config.get('global', 'aerisapi.ville');
consumerId=config.get('global', 'aerisapi.consumerId');
consumerSecret=config.get('global', 'aerisapi.consumerSecret');


api = DomoticzApi()


result = api.call_url("http://api.aerisapi.com/sunmoon/"+ville+"?client_id="+consumerId+"&client_secret="+consumerSecret);
print result;
response=json.loads(result);

phase = response['response'][0]['moon']['phase']['name'].replace(" ", "%20");
api.update_uservariable('lune',phase);
