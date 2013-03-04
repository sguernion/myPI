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
     print 'Plus Button pressed'
     time.sleep(button_delay)
   
def onMin():
     print 'Minus Button pressed'
     time.sleep(button_delay)

def onB():
     print 'Button B pressed'
     time.sleep(button_delay)
   
def onDown():
     print 'Down pressed'
     time.sleep(button_delay)
   
def onUp():
     print 'Up pressed'
     time.sleep(button_delay)   

def onLeft():
     print 'Left pressed'
     time.sleep(button_delay)

def onRight():
     print 'Right pressed'
     time.sleep(button_delay)   
   
def onA():
     print 'Button A pressed'
     time.sleep(button_delay)
   
def on1():
     print 'Button 1 pressed'
     time.sleep(button_delay)   
   
def on2():
     print 'Button 2 pressed'
     time.sleep(button_delay) 
   
def onHome():
     wiic.print_state()
     time.sleep(button_delay)
     
     
     
main()