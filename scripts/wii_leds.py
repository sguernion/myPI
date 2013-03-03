#!/usr/bin/python
#
# Date   : 02/03/2013

# -----------------------
# Import required Python libraries
# -----------------------
import cwiid
import time
import os
import datetime

button_delay = 0.1

print 'Press 1 + 2 on your Wii Remote now ...'
time.sleep(1)

# Connect to the Wii Remote. If it times out
# then quit.
try:
  wii=cwiid.Wiimote()
except RuntimeError:
  print "Error opening wiimote connection"
  quit()

print 'Wii Remote connected...\n'
print 'Press some buttons!\n'
print 'Press PLUS and MINUS together to disconnect and quit.\n'

wii.rpt_mode = cwiid.RPT_BTN
led = 0
led4 = 0
ledv = 0
 
while True:

  buttons = wii.state['buttons']

  # If Plus and Minus buttons pressed
  # together then rumble and quit.
  if (buttons - cwiid.BTN_PLUS - cwiid.BTN_MINUS == 0):  
    print '\nClosing connection ...'
    wii.rumble = 1
    time.sleep(1)
    wii.rumble = 0
    exit(wii)  
  
  # Check if other buttons are pressed by
  # doing a bitwise AND of the buttons number
  # and the predefined constant for that button.
  if (buttons & cwiid.BTN_LEFT):
    print 'Left pressed'
    time.sleep(button_delay)         

  if(buttons & cwiid.BTN_RIGHT):
    kled = 1
    wii.led = kled
    for i in range(4): 
	    kled *= 2%8
	    wii.led = kled
	    time.sleep(.001)
    kled = 8
    for i in range(4): 
	    kled /= 2%8
	    wii.led = kled
	    time.sleep(.001)
    print 'Right pressed'
    time.sleep(button_delay)          

  if (buttons & cwiid.BTN_UP):
    for i in range(16):
        wii.led = i
        time.sleep(.5)
    print 'Up pressed'        
    time.sleep(button_delay)          
    
  if (buttons & cwiid.BTN_DOWN):
    for i in range(16):
        wii.led = i
        wii.rumble = 1-i%2
        time.sleep(.2)
    print 'Down pressed'      
    time.sleep(button_delay)  
    
  if (buttons & cwiid.BTN_1):
    print 'Button 1 pressed'
    time.sleep(button_delay)          

  if (buttons & cwiid.BTN_2):
    print 'Button 2 pressed'
    time.sleep(button_delay)          

  if (buttons & cwiid.BTN_A):
    print 'Binary show'
    led += 1%16
    wii.led = led
    time.sleep(button_delay)          

  if (buttons & cwiid.BTN_B):
    print '4 leds'
    led4 *= 2%8
    wii.led = led4
    time.sleep(button_delay)          

  if (buttons & cwiid.BTN_HOME):
    print wii.state
    print 'Home Button pressed'
    time.sleep(button_delay)           
    
  if (buttons & cwiid.BTN_MINUS): 
    print 'volume led minus'
    ledv /= 2%8
    wii.led = ledv
    time.sleep(button_delay)   
    
  if (buttons & cwiid.BTN_PLUS):
    print 'volume led  plus'
    ledv *= 2%8
    wii.led = ledv
    time.sleep(button_delay)