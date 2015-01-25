commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'
require 'marantz_api'

if(auto()) then

-- Allumage automatique de la lampe quand la tv est allumée et qu'il fait nuit
	if ((devicechanged['Nuit'] == 'On' and otherdevices['P_TV'] == 'On') or (otherdevices['Nuit'] == 'On' and devicechanged['P_TV'] == 'On')) then
		command_scene('Cinema','On')
	end

end



return commandArray