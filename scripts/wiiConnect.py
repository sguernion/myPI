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
         self.wii = None
         self.doloops = True	 
     def connect(self):
         attempts = 1	 
         while not self.wii:
             os.system('clear')
             print 'Press 1 + 2 on your Wii Remote now ...'
             print "Waiting for Wii Remote to Connect..."
             # Connect to the Wii Remote. If it times out
             # then quit.
             try:
                 self.wii=cwiid.Wiimote()
                 print 'Wii Remote connected...\n'
                 print 'Press some buttons!\n'
                 print 'Press PLUS and MINUS together to disconnect and quit.\n'
                 time.sleep(1)
                 self.wii.rpt_mode = cwiid.RPT_BTN
                 self.wii.led = 1
                 doloops = True
                 return self.wii
             except RuntimeError:
                 if attempts > 5:
                     print "Error opening wiimote connection"
                     quit()
             attempts += 1
     def deconnect(self):
         print '\nClosing connection ...'
         self.doloops = False
         self.wii.rumble = 1
         time.sleep(1)
         self.wii.rumble = 0
         self.wii.close 
     def battery(self):
         state = self.wii.state
         return int(100.0 * state['battery'] / cwiid.BATTERY_MAX)
     def buttons(self):
         state = self.wii.state
         return state['buttons']
     def print_state(self):
         state = self.wii.state
         print 'Report Mode:',
         for r in ['STATUS', 'BTN', 'ACC', 'IR', 'NUNCHUK', 'CLASSIC']:
             if state['rpt_mode'] & eval('cwiid.RPT_' + r):
                 print r,
         print
    
         print 'Active LEDs:',
         for led in ['1','2','3','4']:
             if state['led'] & eval('cwiid.LED' + led + '_ON'):
                 print led,
         print
       
         print 'Rumble:', state['rumble'] and 'On' or 'Off'
      
         print 'Battery:', self.battery()
       
         if 'buttons' in state:
             print 'Buttons:', self.buttons()
            
         if 'acc' in state:
             print 'Acc: x=%d y=%d z=%d' % (state['acc'][cwiid.X],
                                            state['acc'][cwiid.Y],
                                            state['acc'][cwiid.Z])    
         if 'ir_src' in state:
             valid_src = False
             print 'IR:',
             for src in state['ir_src']:
                 if src:
                     valid_src = True
                 print src['pos'],
    
                 if not valid_src:
                     print 'no sources detected'
                 else:
                     print
                     
          self.ext_state()           
                     
      def ext_state(self):
          state = self.wii.state 
         if state['ext_type'] == cwiid.EXT_NONE:
             print 'No extension'
         elif state['ext_type'] == cwiid.EXT_UNKNOWN:
             print 'Unknown extension attached'
         elif state['ext_type'] == cwiid.EXT_NUNCHUK:
             print 'Nunchuk: btns=%.2X stick=%r acc.x=%d acc.y=%d acc.z=%d' % \
                 (state['nunchuk']['buttons'], state['nunchuk']['stick'],
                  state['nunchuk']['acc'][cwiid.X],
                  state['nunchuk']['acc'][cwiid.Y],
                  state['nunchuk']['acc'][cwiid.Z])
         elif state['ext_type'] == cwiid.EXT_CLASSIC:
             print 'Classic: btns=%.4X l_stick=%r r_stick=%r l=%d r=%d' % \
                (state['classic']['buttons'],
                 state['classic']['l_stick'], state['classic']['r_stick'],
                 state['classic']['l'], state['classic']['r'])
 
