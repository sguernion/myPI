commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'

if ( devicechanged['D_RASPBOX_POWER'] == 'On' ) then
	if ( otherdevices['P_RASPBOX'] == 'On' and  otherdevices['Alim_Raspbox'] == 'On') then
		 LOG:info('Turning off RaspBox')
		 os.execute("/home/pi/domoticz/scripts/sh/power_off_raspbox.sh")
	elseif ( otherdevices['Alim_Raspbox'] == 'Off' ) then
		command('Alim_Raspbox','On')
	end
end

return commandArray