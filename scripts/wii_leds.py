#!/usr/bin/python

# Date   : 02/03/2013

# -----------------------
# Import required Python libraries
# -----------------------
import cwiid
import time
import os
from wiiConnect import WiiConnect

button_delay = 0.1
 


led = 0
led4 = 1
ledv = 1

def main():
     global wiic
     global wii
     wiic = WiiConnect() 
     wii = wiic.connect()
     while wiic.doloops:
         buttons = wiic.buttons()
         # If Plus and Minus buttons pressed
         # together then rumble and quit.
         if (buttons - cwiid.BTN_PLUS - cwiid.BTN_MINUS == 0):  
             wiic.deconnect(); 
         # Check if other buttons are pressed by
         # doing a bitwise AND of the buttons number
         # and the predefined constant for that button.
         
         if (buttons & cwiid.BTN_LEFT):
             onLeft()
         
         if(buttons & cwiid.BTN_RIGHT):
             onRight()
             
         if (buttons & cwiid.BTN_UP):
             onUp()
          
         if (buttons & cwiid.BTN_DOWN):
             onDown()
         
         if (buttons & cwiid.BTN_1):
             on1()
        
         if (buttons & cwiid.BTN_2):
             on2()
         
         if (buttons & cwiid.BTN_A):
             onA()
          
         if (buttons & cwiid.BTN_B):
             onB()
         
         if (buttons & cwiid.BTN_HOME):
             onHome()
           
         if (buttons & cwiid.BTN_MINUS):
             onMin()
           
         if (buttons & cwiid.BTN_PLUS):
             onPlus()
        
#-- end main loop

def onPlus():
     global ledv
     print 'volume led  plus'
     if ( ledv < 16):
         ledv *= 2%8
     wii.led = ledv
     time.sleep(button_delay)
   
def onMin():
     global ledv
     print 'volume led minus'
     if( ledv > 0 ): 
        ledv /= 2%8
     wii.led = ledv
     time.sleep(button_delay)

def onB():
     global led4
     print '4 leds'
     led4 += led4%16
     wii.led = led4
     time.sleep(button_delay)
   
def onDown():
     for i in range(16):
         wii.led = i
         wii.rumble = 1-i%2
         time.sleep(.2)
     print 'Down pressed'      
     time.sleep(button_delay)  
   
def onUp():
     for i in range(16):
         wii.led = i
         time.sleep(.5)
     print 'Up pressed'        
     time.sleep(button_delay)   

def onLeft():
     print 'Left pressed'
     time.sleep(button_delay)

def onRight():
     kled = 1
     wii.led = kled
     for i in range(4): 
         kled *= 2%8
         wii.led = kled
         time.sleep(.01)
     kled = 8
     for i in range(4): 
         kled /= 2%8
         wii.led = kled
         time.sleep(.01)
     print 'Right pressed'
     time.sleep(button_delay)     
   
def onA():
     global led
     print 'Binary show'
     led += 1%16
     wii.led = led
     time.sleep(button_delay)
   
def on1():
     print 'Battery:',wiic.battery() 
   
def on2():
     print 'Button 2 pressed ',button_delay
     time.sleep(button_delay) 
   
def onHome():
     wiic.print_state()
     time.sleep(button_delay)





main()