commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'

if(auto()) then

if (devicechanged['PHASE'] ~= 'test' and devicechanged['PHASE'] ~= nil) then
	print ("PHASE "..devicechanged['PHASE'])
	command_variable('phase',devicechanged['PHASE'])
end




end	
return commandArray
