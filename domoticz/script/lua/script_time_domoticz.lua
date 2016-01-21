commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Day_class'



local day = Day.create()
local today=os.date("%Y-%m-%d")
if( today ~= getDayVar('jour') ) then
	day:initSaison()
	day:initJoursChome()
	day:initJour()
	day:initSaintJour()
end



if( isTime('20:00')) then
 commandValue('PHASE','soiree')
end

if( isTime('09:00') and not jourChome()) then
 commandValue('PHASE','travail')
end

if( isTime('02:00')) then
 command_variable('cpt_alert_cpu',0)
 command_variable('cpt_alert_mem',0)
 command_variable('cpt_alert_hdd',0)
end


return commandArray
