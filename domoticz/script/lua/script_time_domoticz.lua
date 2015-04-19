commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Day_class'



local day = Day.create()
local today=os.date("%Y-%m-%d")
if( today ~= string.sub(uservariables_lastupdate['jour'],0,10) ) then
	day:initSaison()
	day:initJoursChome()
	day:initJour()
end



time=os.time()
	istime=os.date('%H:%M',time)
	if( istime == '20:00') then
		 commandValue('PHASE','soiree')
	end

	if( istime == '09:00' and not jourChome()) then
		 commandValue('PHASE','travail')
	end


return commandArray