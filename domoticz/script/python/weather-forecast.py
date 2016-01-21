#!/usr/bin/env python

import time
import sys 
import os
from array import array
from datetime import date, time, datetime,timedelta
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *
import ConfigParser

config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/domoticz.properties')
api = DomoticzApi()

API = api.get_conf('domoticz','forecast.api')
LAT = api.get_conf('domoticz','forecast.lat')
LON = api.get_conf('domoticz','forecast.lon')


result = api.call_url("https://api.forecast.io/forecast/"+API+"/"+LAT+","+LON+"?units=ca&exclude=currently,minutely,daily,alerts,flags","","");
response=json.loads(result);

devices_12= ["C_TEMP_ACIGNE_12H","C_VENT_ACIGNE_12H","C_PLUIE_ACIGNE_12H","C_AIR_ACIGNE_12H"]
devices_6 = ["C_TEMP_ACIGNE_6H","C_VENT_ACIGNE_6H","C_PLUIE_ACIGNE_6H","C_AIR_ACIGNE_6H"]


def getMeteo(response,offset,devices):
	maintenant = datetime.now()
	ref=datetime.now() + timedelta(days=0, hours=offset, minutes=0, seconds=0)
	refTime =int(ref.strftime("%s")) - ref.second - (ref.minute *60)
	for count in range(0,49):
		parsed_json = response['hourly']['data'][count]
		time = parsed_json['time']
		if time == refTime:
			print str(count)+" "+str(time)
			temperature = parsed_json['temperature']
			dewPoint = parsed_json['dewPoint']
			#visibility = parsed_json['visibility']
			ozone = parsed_json['ozone']
			humidity = int(parsed_json['humidity'] * 100)
			windSpeed = parsed_json['windSpeed']
			windBearing = parsed_json['windBearing']
			pressure = parsed_json['pressure']
			precipIntensity = parsed_json['precipIntensity']
			precipProbability = parsed_json['precipProbability']
			icon = parsed_json['icon']
			
			if humidity <40:
				status = 2;
			elif humidity >= 40 and humidity < 70 :
				status = 1;
			else: 
				status = 3;
			
			if icon == "clear-day" or icon == "clear-night":
				prediction = 1;
			elif icon == "partly-cloudy-day" or icon == "partly-cloudy-night":
				prediction = 2;
			elif icon == "cloudy":
				prediction = 3;
			elif icon == "rain" or icon == "snow" or icon == "fog" or icon == "sleet":
				prediction = 4;
			else:
				prediction = 0;
				
			if windBearing < 11.25:
				dir = "N";
			elif windBearing >= 11.25 and windBearing < 33.75:
				dir = "NNE";
			elif windBearing >= 33.75 and windBearing < 56.25:
				dir = "NE";
			elif windBearing >= 56.25 and windBearing < 78.75:
				dir = "ENE";
			elif windBearing >= 78.75 and windBearing < 101.25:
				dir = "E";
			elif windBearing >= 101.25 and windBearing < 123.75:
				dir = "ESE";
			elif windBearing >= 123.75 and windBearing < 146.25:
				dir = "SE";
			elif windBearing >= 146.25 and windBearing < 168.75:
				dir = "SSE";
			elif windBearing >= 168.75 and windBearing < 191.25:
				dir = "S";
			elif windBearing >= 191.25 and windBearing < 213.75:
				dir = "SSW";
			elif windBearing >= 213.75 and windBearing < 236.25:
				dir = "SW";
			elif windBearing >= 236.25 and windBearing < 258.75:
				dir = "WSW";
			elif windBearing >= 258.75 and windBearing < 281.25:
				dir = "W";
			elif windBearing >= 281.25 and windBearing < 303.75:
				dir = "WNW";
			elif windBearing >= 303.75 and windBearing < 326.25:
				dir = "NW";
			elif windBearing >= 326.25 and windBearing < 348.75:
				dir = "NNW";
			else:
				dir = "N";
			
			print "temp : "+str(temperature)+" hum : "+str(humidity)+" pressure : "+str(pressure)
			print "windSpeed : "+str(windSpeed)+" windBearing : "+str(windBearing)+" precipIntensity : "+str(precipIntensity)
			print "precipProbability : "+str(precipProbability)+" icon : "+icon+" prediction : "+str(prediction)
			
			idx_temp = config.get('devices', 'idx.'+devices[0]);
			api.set_udevice_state_idx(idx_temp,0,str(temperature)+";"+str(humidity)+";"+str(status)+";"+str(pressure)+";"+str(prediction))
			
			idx_wind = config.get('devices', 'idx.'+devices[1]);
			api.set_udevice_state_idx(idx_wind,0,str(windBearing)+";"+str(dir)+";"+str(windSpeed)+";"+str(windSpeed)+";"+str(temperature)+";"+str(temperature))
			
			idx_rain = config.get('devices', 'idx.'+devices[2]);
			api.set_udevice_state_idx(idx_rain,0,"0;"+str(precipIntensity))
			
			#idx_ozone = config.get('devices', 'idx.'+devices[3]);
			#api.set_udevice_state_idx(idx_ozone,ozone,"PPM")
			

getMeteo(response,6,devices_6)
getMeteo(response,12,devices_12)
