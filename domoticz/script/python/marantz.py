#!/usr/bin/env python

import time
import sys 
import os
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from marantz_api import *

marantz = MarantzApi()

command = sys.argv[1]

if command=='volume_up':
     marantz.volume_up()
elif command=='volume_down':
     marantz.volume_down()
elif command=='source':
     marantz.change_source(sys.argv[2])
elif command=='volume_set':
     marantz.change_volume(sys.argv[2])
elif command=='power_off':
     marantz.call_api('PutZone_OnOff%2FOFF')
elif command=='power_on':
     marantz.call_api('PutZone_OnOff%2FON')
elif command=='mute_off':
     marantz.call_api('PutVolumeMute%2Foff')
elif command=='mute_on':
     marantz.call_api('PutVolumeMute%2Fon')