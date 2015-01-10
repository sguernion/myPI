#!/usr/bin/python
#--------------------------------------   
#       Temperature de la raspberry
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
import os 
import sys

# Tell GPIO library to use GPIO references
GPIO.setmode(GPIO.BCM)

# Set Switch GPIO as input
GPIO.setup(7 , GPIO.IN)

ledV1=11
ledV2=9
ledJ1=10
ledJ2=22
ledR1=17
ledR2=4

LedSeq = [4,17,22,10,9,11]



def powerOn(led):
     GPIO.output(led, True)
     return

def powerOff(led):
     GPIO.output(led, False)
     return

# Return CPU temperature as a character string                                      
def getCPUtemperature():
    res = os.popen('vcgencmd measure_temp').readline()
    return(res.replace("temp=","").replace("'C\n",""))

def display(value):
     if(value >= 16):
        powerOn(ledV1)
     else:
        powerOff(ledV1)
     if(value >= 32):
        powerOn(ledV2)
     else:
        powerOff(ledV2)
     if(value >= 50):
        powerOn(ledJ1)
     else:
        powerOff(ledJ1)
     if(value >= 66):
        powerOn(ledJ2)
     else:
        powerOff(ledJ2)
     if(value >= 82):
        powerOn(ledR1)
     else:
        powerOff(ledR1)
     if(value >= 98):
        powerOn(ledR2)
     else:
        powerOff(ledR2)
     return

def allOff():
     for x in range(len(LedSeq)):
         powerOff(LedSeq[x])
     return

def my_callback(channel):
     allOff()
     GPIO.cleanup()
     sys.exit()
     return

GPIO.setwarnings(False)
# Init
for x in range(len(LedSeq)):
    GPIO.setup(LedSeq[x], GPIO.OUT)
    powerOff(LedSeq[x])


GPIO.add_event_detect(7, GPIO.RISING)
GPIO.add_event_callback(7, my_callback)
CPU_temp = getCPUtemperature()
print CPU_temp
display(int(float(CPU_temp)))
while True :
      #
