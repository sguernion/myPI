#!/usr/bin/python

import socket, json, string, asynchat, asyncore, subprocess, sys, time, urllib2, datetime, base64
import os
import ConfigParser
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from kodi_api import *

command = sys.argv[1]

if command=='up':
     kodi_send(1,"Input.Up","{}")
elif command=='down':
     kodi_send(1,"Input.Down","{}")
elif command=='left':
     kodi_send(1,"Input.Left","{}")
elif command=='right':
     kodi_send(1,"Input.Right","{}")
elif command=='ok':
     kodi_send(1,"Input.Select","{}")
elif command=='back':
     kodi_send(1,"Input.Back","{}")	 
elif command=='play':
     response = kodi_send(1,'Player.GetActivePlayers','{}')
     playerid = response['result'][0]['playerid']
     kodi_send(1,"Player.PlayPause",'{"playerid":'+ str(playerid)+'}')	 
elif command=='stop_player':
     response = kodi_send(1,'Player.GetActivePlayers','{}')
     playerid = response['result'][0]['playerid']
     kodi_send(1,"Player.Back",'{"playerid":'+ str(playerid)+'}')	 
elif command=='shutdown':
     kodi_send(1,"System.Shutdown","{}")	 
elif command=='subtitle':
     kodi_send(1,"Player.SetSubtitle","{}")		 
elif command=='party':
     kodi_send(1,"Player.Open",'{"item":{"partymode":"music"}}')		 
elif command=='vscan':
     kodi_send(1,"VideoLibrary.Scan",'{}')		 
elif command=='ascan':
     kodi_send(1,"AudioLibrary.Scan",'{}')		 
elif command=='vclean':
     kodi_send(1,"VideoLibrary.Clean",'{}')		 
elif command=='aclean':
     kodi_send(1,"AudioLibrary.Clean",'{}')		 
		 	 
	 
	 