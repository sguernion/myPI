#!/usr/bin/python
#
# Date   : 02/03/2013

# -----------------------
# Import required Python libraries
# -----------------------
import time
import os
import datetime
import sys

class Voice:
    def __init__(self):
   
    def time(self):
       now = datetime.datetime.now()
       # TODO format heure
       os.system('flite "'+now.strftime("%H %M")+'" -voice slt -o temp.wav')
       os.system('aplay temp.wav')
       
    def spell(self,stringText):
       os.system('flite "'+stringText+'" -voice slt -o temp.wav')
       os.system('aplay temp.wav')
       
      