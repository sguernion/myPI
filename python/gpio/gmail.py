#!/usr/bin/python

#--------------------------------------   
#     gmail notifier
#
# Author : sguernion
# Date   : 20/05/2013
#
# https://github.com/sguernion/myPI
#
#--------------------------------------

# Import required libraries
import RPi.GPIO as GPIO, feedparser
import time

# On renseigne nos identifiants
USERNAME="gsylvain35"
PASSWORD="password"

# On defini quel PIN est utilise pour brancher la LED
GPIO_PIN=11

# On le defini en sortie
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(GPIO_PIN, GPIO.OUT)
GPIO.output(GPIO_PIN, False)

try:
    # On inspecte le flux RSS
    newmails = int(feedparser.parse("https://" + USERNAME + ":" + PASSWORD + "@mail.google.com/gmail/feed/atom")["feed"]["fullcount"])

    # Si le nombre de mail est superieur a 0 alors on fait clignoter la LED
    if newmails > 0: 
       for i in range(1,58) :
         GPIO.output(GPIO_PIN, True)
         time.sleep(1)
         GPIO.output(GPIO_PIN, False)
         i = i+1
         time.sleep(1)

    # Si il est inferieur a 0 on ne fait rien
    else: 
       GPIO.output(GPIO_PIN, False)
   
except KeyboardInterrupt:
  GPIO.output(GPIO_PIN, False)
  # Reset GPIO settings
  GPIO.cleanup()