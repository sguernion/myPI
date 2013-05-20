#!/usr/bin/python

# Import required libraries
import RPi.GPIO as GPIO
import time


# Tell GPIO library to use GPIO references
GPIO.setmode(GPIO.BCM)

ledV1=9
ledV2=11
ledJ1=22
ledJ2=10
ledR1=4
ledR2=17

LedSeq = [4,17,22,10,9,11]
LedSize = 6


def powerOn(led):
     GPIO.output(led, True)
     return

def powerOff(led):
     GPIO.output(led, False)
     return

def clignote(led,second=0.2):
     powerOn(led)
     time.sleep(second)
     powerOff(led)
     time.sleep(second)
     return 

def clignoteSeq(ledSeq,second=0.2):
     for x in range(len(ledSeq)):
         powerOn(ledSeq[x])
     time.sleep(second)
     for x in range(len(ledSeq)):
         powerOff(ledSeq[x])
     time.sleep(second)
     return

def clignoteManySeq(ledSeq,second=0.2,nb=3):
     for x in range(nb):
         clignoteSeq(ledSeq,second)
     return 


def clignoteMany(led,second=0.2,nb=3):
     for x in range(nb):
         clignote(led,second)
     return

def anim1(nb=3):
     for x in range(nb):
        clignoteManySeq([ledJ1,ledJ2],0.1,1)
        time.sleep(0.1)
        clignoteManySeq([ledV1,ledR2],0.1,1)
        time.sleep(0.1)
        clignoteManySeq([ledV2,ledR1],0.1,1)
        time.sleep(0.1)
     return

def anim2(nb=3):
     for x in range(nb):
        clignoteManySeq([ledV2,ledR1],0.1,1)
        time.sleep(0.1)
        clignoteManySeq([ledV1,ledR2],0.1,1)
        time.sleep(0.1)
        clignoteManySeq([ledJ1,ledJ2],0.1,1)
        time.sleep(0.1)
     return

def chenillardS(nb=3):
     for x in range(nb):
        powerOn(ledV2)
        time.sleep(0.1)
        powerOff(ledV2)
        powerOn(ledV1)
        time.sleep(0.1)
        powerOff(ledV1)
        powerOn(ledJ2)
        time.sleep(0.1)
        powerOff(ledJ2)
        powerOn(ledJ1)
        time.sleep(0.1)
        powerOff(ledJ1)
        powerOn(ledR2)
        time.sleep(0.1)
        powerOff(ledR2)
        powerOn(ledR1)
        time.sleep(0.1)
        powerOff(ledR1)
     return
 
def chenillardSInv(nb=3):
     for x in range(nb):
        powerOn(ledR1)
        time.sleep(0.1)
        powerOff(ledR1)
        powerOn(ledR2)
        time.sleep(0.1)
        powerOff(ledR2)
        powerOn(ledJ1)
        time.sleep(0.1)
        powerOff(ledJ1)
        powerOn(ledJ2)
        time.sleep(0.1)
        powerOff(ledJ2)
        powerOn(ledV1)
        time.sleep(0.1)
        powerOff(ledV1)
        powerOn(ledV2)
        time.sleep(0.1)
        powerOff(ledV2)
     return

def chenillard(nb=3,second=0.1):  
     for x in range(nb):
        allOff()
        powerOn(ledV2)
        time.sleep(second)
        powerOn(ledV1)
        time.sleep(second)
        powerOn(ledJ2)
        time.sleep(second)
        powerOn(ledJ1)
        time.sleep(second)
        powerOn(ledR2)
        time.sleep(second)
        powerOn(ledR1)
        time.sleep(second)
     return 

def chenillardInv(nb=3,second=0.1): 
     for x in range(nb):
        allOff()
        powerOn(ledR1)
        time.sleep(second)
        powerOn(ledR2)
        time.sleep(second)
        powerOn(ledJ1)
        time.sleep(second)
        powerOn(ledJ2)
        time.sleep(second)
        powerOn(ledV1)
        time.sleep(second)
        powerOn(ledV2)
        time.sleep(second)
     return
 
def all(nb=5):
     clignoteManySeq([ledV1,ledV2,ledJ1,ledJ2,ledR1,ledR2],0.1,nb)
     time.sleep(0.1)
     return

def allOff():
     for x in range(len(LedSeq)):
         powerOff(LedSeq[x])
     return

# Init
for x in range(len(LedSeq)):
    GPIO.setup(LedSeq[x], GPIO.OUT)
    powerOff(LedSeq[x])

all(5)
clignoteManySeq([ledJ1,ledJ2],0.1,5)
time.sleep(0.1)
clignoteManySeq([ledV1,ledV2,ledR1,ledR2],0.1,5)
time.sleep(0.1)

anim1(2)
all(3)
anim2(2)

chenillardS(1)
chenillardSInv(1)
chenillardS(1)
chenillardSInv(1)
chenillardS(1)
chenillardSInv(1)

chenillard(1)
chenillardInv(1)

chenillard(1,0.5)
chenillardInv(1,0.5)
chenillard(4,0.1)
chenillardInv(4,0.1)
chenillard(1)
chenillardInv(1)

allOff()



# Reset GPIO settings
GPIO.cleanup()