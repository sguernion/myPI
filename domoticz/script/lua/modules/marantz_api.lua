
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'Properties_class'

Marantz = {}
Marantz.__index = Marantz

function Marantz.create(server,port,zone)
   local mrt = {}             -- our new object
   setmetatable(mrt,Marantz)  -- make Marantz handle lookup
   mrt.server = server
   mrt.port = port
   mrt.zone = zone
   return mrt
end

function Marantz.createFromConf(config)
   local mrt = {}             -- our new object
   setmetatable(mrt,Marantz)  -- make Marantz handle lookup
   properties = Properties.create(config)
   mrt.server = properties:get('marantz.host')
   mrt.port = properties:get('marantz.port')
   mrt.zone = properties:get('marantz.zone')
   return mrt
end


-- 
function Marantz:call_api(text)
	commandArray['OpenURL']='http://' .. self.server .. ':' .. self.port .. '/' .. self.zone .. '/index.put.asp?' .. text
end

function Marantz:change_source(source)
	self:call_api('cmd0=PutZone_InputFunction%2F'..source )
end

function Marantz:change_volume(decibel)
	self:call_api('cmd0=PutMasterVolumeSet%2F'..decibel )
end

function Marantz:volume_up()
	self:call_api('cmd0=PutMasterVolumeBtn%2F%3E' )
end

function Marantz:volume_down()
	self:call_api('cmd0=PutMasterVolumeBtn%2F%3C' )
end

function Marantz:volume_mute()
	self:call_api('cmd0=PutVolumeMute%2Fon' )
end

function Marantz:volume_unmute()
	self:call_api('cmd0=PutVolumeMute%2Foff' )
end

function Marantz:power(value)
	self:call_api('cmd0=PutZone_OnOff%2F'..value )
end

function Marantz:power_off()
	self:power('OFF')
end

function Marantz:power_on()
	self:power('ON')
end


-- Use
-- marantz = Marantz.create('192.168.0.11','80','MainZone')
-- marantz:power_on()