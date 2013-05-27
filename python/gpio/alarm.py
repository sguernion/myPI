#!/usr/bin/python

#--------------------------------------   
#     Alarm
#
# Author : sguernion
# Date   : 20/05/2013
#
# https://github.com/sguernion/myPI
#
#--------------------------------------

# Import required libraries
import RPi.GPIO as GPIO
import time
import sys

# Tell GPIO library to use GPIO references
GPIO.setmode(GPIO.BCM)

# Configure GPIO8 as an outout
GPIO.setup(8, GPIO.OUT)

# Set Switch GPIO as input
GPIO.setup(7 , GPIO.IN)

#4,17
LedSeq = [4]
LedSize = 1



for x in range(LedSize):
    GPIO.setup(LedSeq[x], GPIO.OUT)
    GPIO.output(LedSeq[x], False)

# Turn Buzzer off
GPIO.output(8, False)





alarm = True

def my_callback(channel):
    global alarm
    alarm = False
    GPIO.cleanup()
    sys.exit()
    return

try:
  GPIO.add_event_detect(7, GPIO.RISING)
  GPIO.add_event_callback(7, my_callback)
  # Loop until users quits with CTRL-C
  while alarm :
    # Turn Buzzer on
    GPIO.output(8, True)
    for x in range(LedSize):
         GPIO.output(LedSeq[x], True)
    
    # Wait 1 second
    time.sleep(0.5)

    # Turn Buzzer off
    GPIO.output(8, False)
    for x in range(LedSize):
         GPIO.output(LedSeq[x], False)
    time.sleep(0.2)
	
	# long sequence
	# Turn Buzzer on
    GPIO.output(8, True)
    for x in range(LedSize):
         GPIO.output(LedSeq[x], True)
    
    # Wait 1 second
    time.sleep(1)

    # Turn Buzzer off
    GPIO.output(8, False)
    for x in range(LedSize):
         GPIO.output(LedSeq[x], False)
    time.sleep(0.5)
      
except KeyboardInterrupt:
  # Reset GPIO settings
  GPIO.cleanup()
