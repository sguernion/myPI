#!/usr/bin/env python

import time
import sys 
import os
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *

variable = sys.argv[1]
command = sys.argv[2]

api = DomoticzApi()

api.update_uservariable(variable,command)

