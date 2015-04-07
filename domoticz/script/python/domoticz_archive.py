#!/usr/bin/env python

import time
import sys 
import os
import json
import base64
import urllib2
import urllib
import requests
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *

#config
config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/config.properties')


dds_url=config.get('domoticzDs', 'dds.url');
dds_user=config.get('domoticzDs', 'dds.user');
dds_pass=config.get('domoticzDs', 'dds.pass');




api = DomoticzApi()

s = requests.Session()
s.auth = (dds_user,dds_pass)

def call_url(url,jsonData):
	#print url
	headers = {}
	headers['Content-Type'] = 'application/json'
	headers['Connection'] = 'keep-alive'
	request = urllib2.Request(url,jsonData,headers)
	req= urllib2.urlopen(request)
	res = req.read()
	return res

def post_url(session,url,jsonData):
	print url
	r = session.post(url, jsonData)
	#print r.status_code
	#if r.status_code == 200 :
		#print r.json
	return r
	
def get_url(session,url):
	#print url
	r = session.get(url)
	#print r.status_code
	return r
	
def put_url(session,url,jsonData):
	#print url
	r = session.put(url, jsonData)
	#print r.status_code
	#if r.status_code == 200 :
	#	print r.json
	return r

def updateLog(dds_url,url,switch,urlSuffix):
	response3 = json.loads(api.call_api(url+str(switch['idx'])+urlSuffix))
	if response3['status'] != 'ERR' :
		print 'update switch log'
		if 'result' in response3:
			existLog = get_url(s,dds_url+'/deviceLog/'+str(switch['idx'])+'/logs')
			for log in response3['result']:
				#print existLog.content
				if existLog.status_code == 200:
					#print str(log['idx'])+" "+str(existLog.json['idx'])+" = "+str(int(log['idx']) > int(existLog.json['idx']))
					if str(switch['Type']) == 'Lighting 2' or str(switch['Type']) == 'Scene':
						if existLog.content == '' or int(log['idx']) > int(existLog.json['idx']):
							dataLogfull ={"Data": str(log['Data']),"Date": str(log['Date']),"Level": str(log['Level']),"Status": str(log['Status']),"idx": str(log['idx'])}
							print 'create switch log '+log['Date']
							post_url(s,dds_url+'/deviceLog/'+str(switch['idx'])+'/logs/',dataLogfull)
					else:
						if existLog.content == '' or str(log['d']) > str(existLog.json['d']):
							dataLogfull ={"Status": str(log['te']),"Date": str(log['d'])}
							print 'create switch log '+log['d']
							post_url(s,dds_url+'/deviceLog/'+str(switch['idx'])+'/logs/',dataLogfull)
	

result = post_url(s,dds_url+'/auth/signin',{"username":dds_user,"password":dds_pass})
print result
response = json.loads(api.call_api('type=devices&filter=all&used=true&order=Name'))
for switch in response['result']:
	print 'switch exist '+str(switch['Name'])+' ?'
	exist = get_url(s,dds_url+'/device/'+str(switch['idx']))
	response2 = json.loads(api.call_api('type=devices&rid='+str(switch['idx'])))
	#datafull={"BatteryLevel": str(response2['result'][0]['BatteryLevel']),"CustomImage": str(response2['result'][0]['CustomImage']),"Data": str(response2['result'][0]['Data']),"Favorite": str(response2['result'][0]['Favorite']),"HardwareID": str(response2['result'][0]['HardwareID']),"HardwareName": str(response2['result'][0]['HardwareName']),"HaveDimmer": str(response2['result'][0]['HaveDimmer']),"HaveGroupCmd": str(response2['result'][0]['HaveGroupCmd']),"HaveTimeout": str(response2['result'][0]['HaveTimeout']),"ID": str(response2['result'][0]['ID']),"Image": str(response2['result'][0]['Image']),"IsSubDevice": str(response2['result'][0]['IsSubDevice']),"LastUpdate": str(response2['result'][0]['LastUpdate']),"Level": str(response2['result'][0]['LastUpdate']),"LevelInt": str(response2['result'][0]['LevelInt']),"MaxDimLevel": str(response2['result'][0]['MaxDimLevel']),"name": str(response2['result'][0]['Name']),"Notifications": str(response2['result'][0]['Notifications']),"PlanID": str(response2['result'][0]['PlanID']),"Protected": str(response2['result'][0]['Protected']),"ShowNotifications": str(response2['result'][0]['ShowNotifications']),"SignalLevel": str(response2['result'][0]['SignalLevel']),"Status": str(response2['result'][0]['Status']),"StrParam1": str(response2['result'][0]['StrParam1']),"StrParam2": str(response2['result'][0]['StrParam2']),"SubType": str(response2['result'][0]['SubType']),"SwitchType": str(response2['result'][0]['SwitchType']),"SwitchTypeVal": str(response2['result'][0]['SwitchTypeVal']),"Timers": str(response2['result'][0]['Timers']),"type": str(response2['result'][0]['Type']),"typeImg": str(response2['result'][0]['TypeImg']),"Unit": str(response2['result'][0]['Unit']),"Used": str(response2['result'][0]['Used']),"usedByCamera": str(response2['result'][0]['UsedByCamera']),"xOffset": str(response2['result'][0]['XOffset']),"yOffset": str(response2['result'][0]['YOffset']),"idx": str(response2['result'][0]['idx'])}
	
	if response2['result'][0].has_key('Status'):
		data={"name":str(switch['Name']),"status":response2['result'][0]['Status'],"type":str(switch['Type']),"typeImg":response2['result'][0]['TypeImg'],"idx":str(switch['idx']),"content":str('Last Seen :'+response2['result'][0]['LastUpdate']+' Status :'+response2['result'][0]['Status'])}
	else:
		data={"name":str(switch['Name']),"status":response2['result'][0]['Data'],"type":str(switch['Type']),"typeImg":response2['result'][0]['TypeImg'],"idx":str(switch['idx']),"content":str('Last Seen :'+response2['result'][0]['LastUpdate']+' Status :'+response2['result'][0]['Data'])}
	
	
	#print data
	if exist.status_code == 200 :
		print 'update switch'
		put_url(s,dds_url+'/device/'+str(switch['idx']),data)
	else:
		print 'create switch'
		post_url(s,dds_url+'/devices/',data)

	if str(switch['Type']) == 'Lighting 2' or str(switch['Type']) == 'Scene':
		updateLog(dds_url,'type=lightlog&idx=',switch,'')
			
	else:
		updateLog(dds_url,'type=graph&sensor=temp&idx=',switch,'&range=day')
		

