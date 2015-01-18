commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'
require 'marantz_api'

if(auto()) then
	-- extinction de tout les appareils
	if ( devicechanged['Mode Nuit'] == 'On') then
		devicesOff()
	end


	difference = time_difference('P_Smartphone')
	if (devicechanged['P_Smartphone'] == 'On' or  devicechanged['Mode Nuit'] == 'Off') then
		   print('presence Wifi Go Home')
		   command_scene('Presence','On')
	elseif (not presenceAtHome() and difference > 60 and difference < 240) then
		   devicesOff()
	end

end

if(absence()) then
	devicesOff()
end


return commandArray
