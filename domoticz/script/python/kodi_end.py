#!/usr/bin/env python
from urllib2 import urlopen
from json import loads
from time import time
import socket, json, string, sys, urllib2, datetime, base64
import os
import ConfigParser
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from kodi_api import *
from domoticz_api import *

debug = 1

# Domoticz uservariable
uservarid_kodi_play_duration = config.get('domoticz', 'idx.v_kodi_play_duration');
kodi_play_duration = = config.get('domoticz', 'name.v_kodi_play_duration');
kodi_play_duration_type = config.get('domoticz', 'type.v_kodi_play_duration');

# Do not change anything beyond this line.
#___________________________________________________________________________________________________

def get_video_end():
     response = kodi_send(1,'Player.GetActivePlayers','{}')
     mediatype = response['result'][0]['type']
     playerid = response['result'][0]['playerid']

     if mediatype == 'video':
         response = kodi_send(1,'Player.GetProperties','{"playerid":' + str(playerid) +',"properties":["totaltime","percentage","time"]}')
         t_time = (((response['result']['totaltime']['hours']*60+response['result']['totaltime']['minutes']))*60)+response['result']['totaltime']['seconds']
         p_time = (((response['result']['time']['hours']*60+response['result']['time']['minutes']))*60)+response['result']['time']['seconds']
         r_time = t_time - p_time

         duration = str(datetime.timedelta(seconds=r_time))
         if debug == 1:
             print("0"+duration[0:-3])
         return "0"+duration[0:-3]


def update_video_end(kodi_play_duration,play_duration,play_duration_type):
     duration = get_video_end()
     update_uservariable(kodi_play_duration,play_duration,play_duration_type,duration)
		 
update_video_end(uservarid_kodi_play_duration,kodi_play_duration,kodi_play_duration_type)