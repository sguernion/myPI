commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'xbmc_api'

if ( devicechanged['Xbmc Play/Pause'] == 'On' or devicechanged['Xbmc Play/Pause'] == 'Off') then
	xbmc = Xbmc.createFromConf(uservariables["config_file"])
	xbmc:play_pause()
end

return commandArray