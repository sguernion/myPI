commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Mqtt_class'

local Mqtt = Mqtt.createFromConf(uservariables["config_file"])
Mqtt:connect('domoticz')

for i, v in pairs(uservariablechanged) do
		tc = tostring(i)
		LOG:info(tc.." "..v )
		json = '{"name:"'..tc..'","value":"'..v..'","type":""} '
		Mqtt:publish(Mqtt.varPath , json)	
	end

	
Mqtt:destroy()
	
return commandArray
