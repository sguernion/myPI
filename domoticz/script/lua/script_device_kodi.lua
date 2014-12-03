commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'
require 'kodi_api'


if (devicechanged['P_Kodi'] == 'Off') then
        print('Turning off Kodi')
		kodi = Kodi.createFromConf(uservariables["config_file"])
		kodi:halt()
		command_variable('kodi_play_duration',"00:00")
        commandArray['Multimedia']='Off AFTER 150'
end

if ( devicechanged['Kodi Play/Pause'] == 'On' or devicechanged['Kodi Play/Pause'] == 'Off') then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:play_pause()
end

if (devicechanged['P_Kodi'] == 'On' and uservariables["source_tv"] == 1) then
	 commandArray['TV_SOURCE']='On'
end	



return commandArray