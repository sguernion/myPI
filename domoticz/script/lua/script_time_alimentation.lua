commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'

differenceRB = time_difference('P_RaspBox')

if (otherdevices['P_RaspBox'] == 'Off' and otherdevices['Alim_Raspbox'] == 'On' and differenceRB > 240 and differenceRB < 600) then
	commandArray['Alim_Raspbox'] = 'Off'
end


differenceXbmx = time_difference('P_Kodi')

if (otherdevices['P_Kodi'] == 'Off' and otherdevices['Alim_Kodi'] == 'On' and differenceXbmx > 240 and differenceXbmx < 600) then
	commandArray['Alim_Kodi'] = 'Off'
end
	
return commandArray
