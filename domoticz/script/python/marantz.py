#!/usr/bin/env python

import time
import sys 
import os
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from marantz_api import *



command + sys.argv[1]

if command=='volume_up':
     volume_up()
elif command=='volume_down':
     volume_down()
elif command=='source':
     change_source(sys.argv[2])
elif command=='volume_set':
     change_volume(sys.argv[2])
elif command=='power_off':
     call_api('PutZone_OnOff%2FOFF')
elif command=='power_on':
     call_api('PutZone_OnOff%2FON')
elif command=='mute_off':
     call_api('PutVolumeMute%2Foff')
elif command=='mute_on':
     call_api('PutVolumeMute%2Fon')