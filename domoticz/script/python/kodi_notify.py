#!/usr/bin/python
import socket, json, string, asynchat, asyncore, subprocess, sys, time, urllib2, datetime, base64
import os
import ConfigParser
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from kodi_api import *

kodimachine = KODIClient(kodi_host, kodi_port)
while kodimachine.connection_state != "connected":
       print "try to connect"
       try:
           kodimachine.connect((kodi_host, kodi_port))
       except Exception,e:
           print e

print kodimachine.connection_state 
sendmessagetokodi(kodimachine, sys.argv[1])