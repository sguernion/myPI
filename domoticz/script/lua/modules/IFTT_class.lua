package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'Properties_class'

IFTT = {}
IFTT.__index = IFTT

function IFTT.create(event,key)
   local mrt = {}             -- our new object
   setmetatable(mrt,IFTT)  --  IFTT handle lookup
   mrt.event=event
   mrt.key=key
   return mrt
end

function IFTT.createFromConf(config)
   local mrt = {}             -- our new object
   setmetatable(mrt,IFTT)  --  IFTT handle lookup
   properties = Properties.create(config)
   mrt.event=properties:get('iftt.event')
   mrt.key=properties:get('iftt.key')
   return mrt
end


function IFTT:query(query)
    os.execute('curl -s -i -H "Accept: application/json" "https://maker.ifttt.com/trigger/'.. self.key ..'/with/key/'.. self.key ..'?'..query..'"')
end

function IFTT:send(value1,value2,value3)
    self:query('value1='..value1..'&value2='..value2..'&value3='..value3)
end

