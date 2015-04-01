commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'

if(auto()) then

	if ( devicechanged['Scene:Reveil_Sylvain'] == 'On' ) then
		command_variable('phase','lever')
	end
	
	if ( devicechanged['Scene:Retour'] == 'On' ) then
		command_variable('phase','retour')
	end
	
	if ( devicechanged['Scene:Soiree'] == 'On' ) then
		command_variable('phase','soiree')
	end

	if ( devicechanged['Scene:Coucher_General'] == 'On' ) then
		command_variable('phase','coucher')
	end

end	
return commandArray
