commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'

if(auto()) then
	time_min=to_seconde(4)
	time_max=to_seconde(10)
	
	-- Coupe l'alimentation une fois RASPBOX soit éteint après un certain delai 
	alimOff_AfterDeviceShutdown('P_RASPBOX','Alim_Raspbox',time_min,time_max)

	-- Coupe l'alimentation une fois Kodi soit éteint après un certain delai 
	alimOff_AfterDeviceShutdown('P_KODI','Alim_Kodi',time_min,time_max)
	
end	
return commandArray
