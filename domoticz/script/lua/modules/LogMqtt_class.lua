package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'Mqtt_class'

LogMqtt = {}
LogMqtt.__index = LogMqtt

function LogMqtt.create()
   local mrt = {}             -- our new object
   setmetatable(mrt,LogMqtt)  -- make LogMqtt handle lookup
   mrt.sendToMqtt = true;
   mrt.MQTT = Mqtt.createFromConf(uservariables["config_file"])
   mrt.MQTT:connect('domoticz')
   mrt.level = uservariables['log_level']
   return mrt
end


function LogMqtt:debug(message) 
	if(self:isDebug()) then
		print('DEBUG:'..message);
		if(self.sendToMqtt) then
			self.MQTT:publish(self.MQTT.logPath .. 'DEBUG', message)	
		end
	end
end

function LogMqtt:info(message) 
	if(self:isInfo() or self:isDebug()) then
		print('INFO:'..message);
		if(self.sendToMqtt) then
			self.MQTT:publish(self.MQTT.logPath .. 'INFO', message)	
		end
	end
end

function LogMqtt:warn(message) 
	if(self:isWarn() or self:isInfo() or self:isDebug()) then
		print('WARN:'..message);
		if(self.sendToMqtt) then
			self.MQTT:publish(self.MQTT .. 'WARN', message)	
		end
	end
end

function LogMqtt:error(message) 
	if(self:isError() or self:isInfo() or self:isWarn() or self:isDebug()) then
		error('ERROR:'..message);
		if(self.sendToMqtt) then
			self.MQTT:publish(self.MQTT .. 'ERROR', message)	
		end
	end
end

function LogMqtt:isDebug() 
	return (self.level == "debug")
end

function LogMqtt:isInfo() 
	return (self.level == "info")
end

function LogMqtt:isWarn() 
	return (self.level == "warn")
end

function LogMqtt:isError() 
	return (self.level == "error")
end
