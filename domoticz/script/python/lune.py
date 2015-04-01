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
idx_var_lune=config.get('domoticz', 'idx.v_lune');
name_var_lune=config.get('domoticz', 'name.v_lune');
type_var_lune=config.get('domoticz', 'type.v_lune');

result = call_url("http://api.aerisapi.com/sunmoon/"+ville+"?client_id="+consumerId+"&client_secret="+consumerSecret);
print result;
response=json.loads(result);

phase = response['response'][0]['moon']['phase']['name'].replace(" ", "%20");
update_uservariable(idx_var_lune,name_var_lune,type_var_lune,phase);
