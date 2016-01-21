#!/usr/bin/env python

import time
import sys 
import os
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *
import ConfigParser

config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/domoticz.properties')

device = sys.argv[1]
command = sys.argv[2]

api = DomoticzApi()

idx_switch = config.get('devices', 'idx.'+device);
api.set_state_idx(idx_switch,command)