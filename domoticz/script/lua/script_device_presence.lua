commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'

local delai_min = 60
local delai_max = 240

if(auto()) then
	-- extinction de tout les appareils
	if ( devicechanged['Mode Nuit'] == 'On') then
		devicesOff()
	end

	if (oneDeviceChangeHasState('P_Smartphone','On') and otherdevices['Mode Nuit'] == 'Off') then
		   print('presence Wifi Go Home')
		   command_scene('Presence','On')
		   commandValue('PHASE','retour');
	elseif (devicechanged['Mode Nuit'] == 'Off' and oneDeviceHasState('P_Smartphone','On')) then
		   print('presence : Levée')
		   command_scene('Presence','On')
	elseif (not presenceAtHome() and oneDeviceTime_difference_between('P_Smartphone',delai_min,delai_max)) then
		   devicesOff()
	end

end

if(absence() and otherdevices['MultipriseS'] == 'On' ) then
	devicesOff()
end


return commandArray
