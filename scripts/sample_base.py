#!/usr/bin/python

# Date   : 02/03/2013

# -----------------------
# Import required Python libraries
# -----------------------
import cwiid
import time
import os

 
class WiiConnect:
    def __init__(self):
	    wii = None
        attempts = 1
        global button_delay = 0.1
		global doloops = true
    def connect(self):
		while not wii:
            os.system("clear")
            print 'Press 1 + 2 on your Wii Remote now ...'
            print "Waiting for Wii Remote to Connect..."
            # Connect to the Wii Remote. If it times out
            # then quit.
            try:
                wii=cwiid.Wiimote()
			
			    print 'Wii Remote connected...\n'
                print 'Press some buttons!\n'
                print 'Press PLUS and MINUS together to disconnect and quit.\n'
		        wii.rpt_mode = cwiid.RPT_BTN
		        wii.led = 1
		        doloops = true
			    return wii
            except RuntimeError:
		        if attempts > 5:
                    print "Error opening wiimote connection"
                    quit()	
            attempts += 1
    def deconnect(self):
        print '\nClosing connection ...'
		doloops = flase
        wii.rumble = 1
        time.sleep(1)
        wii.rumble = 0
        exit(self.wii) 
    def battery(self):
        state = wiimote.state
        bat = int(100.0 * state['battery'] / cwiid.BATTERY_MAX)
        print 'battery status : '+bat
    def buttons(self):
        state = wiimote.state
        return wii.state['buttons']
 
 

def main():
    wiic = WiiConnect() 
    wii = wiic.connect()
 
    while doloops:

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
   print Left pressed'
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
   print wii.state
   print 'Minus Button pressed'
   time.sleep(button_delay)