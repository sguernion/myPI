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
from utils.spell import Voice


def main(argv):
   stringText = ''
   try:
      opts, args = getopt.getopt(argv,"hs:t:",["s=","time="])
   except getopt.GetoptError:
      print 'voice.py -s <stringText> -t'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-s':
          voice = Voice()
          voice.spell(stringText)
          sys.exit()
      elif opt in ("-t", "--time"):
          voice = Voice()
          voice.time()
          sys.exit()

if __name__ == "__main__":
   main(sys.argv[1:])
  
    
 