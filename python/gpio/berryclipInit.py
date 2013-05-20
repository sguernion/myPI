#!/usr/bin/python

# Import required libraries
import RPi.GPIO as GPIO
import time

# Tell GPIO library to use GPIO references
GPIO.setmode(GPIO.BCM)

# Configure GPIO8 as an outout
GPIO.setup(8, GPIO.OUT)

# Turn Buzzer off
GPIO.output(8, False)

# Reset GPIO settings
GPIO.cleanup()