
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'Properties_class'
require 'Log_class'

--[[
MQTT demo device script
 
devicechanges are pushed to localhost port 5001 if there's any value to publish
a node.js script like this is waiting and publishes using mqtt
 
var url = require("url");
var http = require('http');
var pubclient = new mqtt.MQTTClient(1883, '127.0.0.1', 'domoticz');
 
http.createServer(function (req, res) {
	res.writeHead(200, {'Content-Type': 'text/plain'});
	res.end('Response from Node.js \n');
	pubclient.publish('/events/domoticz'+url.parse(req.url).pathname, url.parse(req.url).query);	
}).listen(5001, '127.0.0.1');
 
NB. Domoticz will add _ and property to the name of certain sensors (e.g. _temperature, _humidity). This is passed as lowest level of message in mqtt
--]]
Mqtt = {}
Mqtt.__index = Mqtt
local MQTT = require("mqtt_library")

function Mqtt.create(server,port)
   local mrt = {}             -- our new object
   setmetatable(mrt,Mqtt)  -- make Mqtt handle lookup
   mrt.server = server
   mrt.port = port
   mrt.clientName = "domoticz"
   mrt.eventPath = "domoticz/events/"
   mrt.logPath = "domoticz/logs/"
   mrt.varPath = "domoticz/uservariables/"
   mrt.MQTT = MQTT
   mrt.mqtt_client = {}
   mrt.LOG = Log.create()
   return mrt
end

function Mqtt.createFromConf(config)
   local mrt = {}             -- our new object
   setmetatable(mrt,Mqtt)  -- make Mqtt handle lookup
   properties = Properties.create(config)
   mrt.server = properties:get('mqtt.host')
   mrt.port = properties:get('mqtt.port')
   mrt.clientName = "domoticz"
   mrt.eventPath = "domoticz/events/"
   mrt.logPath = "domoticz/logs/"
   mrt.varPath = "domoticz/uservariables/"
   mrt.MQTT = MQTT
   mrt.mqtt_client = {}
   mrt.LOG = Log.create()
   return mrt
end

function Mqtt:connect()
	--self.MQTT.Utility.set_debug(self.LOG:isDebug())
	if(self:enable()) then 
		self.mqtt_client = MQTT.client.create(self.server,self.port)
		self.mqtt_client:connect(self.clientName)
	end
end

function Mqtt:publish(channel, valeur)
	if(self:enable()) then 
		self.LOG:debug ('publish '.. channel .. ' : ' .. valeur)
		self.mqtt_client:publish(channel, valeur)
	else
		self.LOG:debug('publish(simul) '.. channel .. ' : ' .. valeur)
	end
end

function Mqtt:destroy()
	if(self:enable()) then 
		self.mqtt_client:destroy()
	end
end

function Mqtt:enable() 
	return uservariables['mqtt_enable']=="true"
end
