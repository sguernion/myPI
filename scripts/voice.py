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


def main(argv):
   stringText = ''
   try:
      opts, args = getopt.getopt(argv,"hs:t:",["s=","time="])
   except getopt.GetoptError:
      print 'voice.py -s <stringText> -t'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-s':
         os.system('flite "'+stringText+'" -voice slt -o temp.wav')
         os.system('aplay temp.wav')
         sys.exit()
      elif opt in ("-t", "--time"):
         now = datetime.datetime.now()
		 # TODO format heure
         os.system('flite "'+now.strftime("%H %M")+'" -voice slt -o temp.wav')
         os.system('aplay temp.wav')
         sys.exit()

if __name__ == "__main__":
   main(sys.argv[1:])
  
    
 