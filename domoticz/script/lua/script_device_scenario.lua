commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'


if(auto()) then

	-- Allumage automatique de la lampe quand la tv est allumée et qu'il fait nuit
	if ((devicechanged['Nuit'] == 'On' and otherdevices['P_TV'] == 'On') or (otherdevices['Nuit'] == 'On' and devicechanged['P_TV'] == 'On')) then
		command_scene('Cinema','On')
	end

	-- Allumage automatique de la lampe lorsqu'il fait nuit et la porte d'entrée vient de s'ouvrir
	if (not presenceAtHome() and otherdevices['Nuit'] == 'On' and oneDeviceChangeHasState('Porte','Open')) then
		command_scene('Retour','On')
	end
	
	
end



return commandArray