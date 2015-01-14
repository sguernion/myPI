#!/usr/bin/env python

import time
import sys 
import os
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *

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
	# TODO Send SMS


set_udevice_state_idx(8,col,risk);