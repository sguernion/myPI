commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'

differenceRB = time_difference('P_RaspBox')

if (otherdevices['P_RASPBOX'] == 'Off' and otherdevices['Alim_Raspbox'] == 'On' and differenceRB > 240 and differenceRB < 600) then
	commandArray['Alim_Raspbox'] = 'Off'
end


differenceXbmx = time_difference('P_KODI')

if (otherdevices['P_KODI'] == 'Off' and otherdevices['Alim_Kodi'] == 'On' and differenceXbmx > 240 and differenceXbmx < 600) then
	commandArray['Alim_Kodi'] = 'Off'
end
	
return commandArray
