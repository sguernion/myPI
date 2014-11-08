#!/usr/bin/env python

import time
import sys 
import os
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *


guirlande = '54' # guirlande noel
mode = '55' # mode noel

var_mode = 1

def powerOn(name):
     set_state_idx(name,'On')
     return

def powerOff(name):
     set_state_idx(name,'Off')
     return
	 
def clignote(led,second=0.2):
     powerOn(led)
     time.sleep(second)
     powerOff(led)
     time.sleep(second)
     return 
	 
def main():	 
    while get_state_idx(mode)=='On' :
         if var_mode == 0:
            clignote(guirlande,0.5)
         if var_mode == 1:
            if get_state_idx(guirlande)=='Off':
     	        powerOn(guirlande)
    powerOff(guirlande)


try:
    main()
except KeyboardInterrupt:
    powerOff(guirlande)
    pass
    