commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'

if(auto()) then
	if(devicechanged['PHASE']) then
		print('update variable ' .. otherdevices_svalues['PHASE'])
		command_variable('phase',otherdevices_svalues['PHASE'])
	end	
end	
return commandArray