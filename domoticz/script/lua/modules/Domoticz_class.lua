package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'Properties_class'

Domoticz = {}
Domoticz.__index = Domoticz

function Domoticz.create(ip,port)
   local mrt = {}             -- our new object
   setmetatable(mrt,Domoticz)  --  Domoticz handle lookup
   mrt.ip=ip
   mrt.port=port
   return mrt
end

function Domoticz.createFromConf(config)
   local mrt = {}             -- our new object
   setmetatable(mrt,Domoticz)  --  Domoticz handle lookup
   properties = Properties.create(config)
   mrt.ip=properties:get('domoticz.ip')
   mrt.port=properties:get('domoticz.port')
   return mrt
end


function Domoticz:query(query)
    os.execute('curl -s -i -H "Accept: application/json" "http://' .. self.ip ..':'.. self.port ..'/json.htm?'.. query ..'"')
end


function Domoticz:reboot()
	self:query('type=command&param=system_reboot')
end

function Domoticz:resetCache()
	os.execute('sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches" >/dev/null 2>&1')
end

function Domoticz:backup()
	os.execute('sudo /home/pi/domoticz/scripts/sh/domoticz_backup.sh &')
end

--TODO peux prendre plus de 10 sec
function Domoticz:addVariable(uservariabletype,uservariablename,uservariablevalue)
	if(uservariables[uservariablename] == nil) then
		LOG:info("addVariable "..uservariabletype.." : "..uservariablename.." = "..uservariablevalue)
		--self:query('type=command&param=saveuservariable&vname='..uservariablename..'&vtype='..tostring(uservariabletype)..'&vvalue='..tostring(uservariablevalue))
	end
end

function Domoticz:deleteVariable(uservariableIdx)
	if(uservariables[uservariablename] == nil) then
		self:query('type=command&param=deleteuservariable&idx='..uservariableIdx)
	end
end

function Domoticz:addVariable(uservariableIdx,uservariabletype,uservariablename,uservariablevalue)
	if(uservariables[uservariablename] == nil) then
		self:query('type=command&param=updateuservariable&idx='..uservariableIdx ..'&vname='..uservariablename..'&vtype='..tostring(uservariabletype)..'&vvalue='..tostring(uservariablevalue))
	end
end