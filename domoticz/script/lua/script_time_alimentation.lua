commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'

if(auto()) then
	differenceRB = time_difference('P_RASPBOX')
	time_min=240
	time_max=600

	if (otherdevices['P_RASPBOX'] == 'Off' and otherdevices['Alim_Raspbox'] == 'On' and differenceRB > time_min and differenceRB < time_max) then
		command('Alim_Raspbox','Off')
	end


	differenceXbmx = time_difference('P_KODI')

	if (otherdevices['P_KODI'] == 'Off' and otherdevices['Alim_Kodi'] == 'On' and differenceXbmx > time_min and differenceXbmx < time_max) then
		command('Alim_Kodi','Off')
	end
end	
return commandArray
