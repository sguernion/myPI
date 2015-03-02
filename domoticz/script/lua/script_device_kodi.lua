commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Kodi_class'



if ( devicechanged['D_KODI_PLAY'] == 'On' or devicechanged['D_KODI_PLAY'] == 'Off') then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:play_pause()
end

if ( devicechanged['D_KODI_PARTY'] == 'On' ) then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:party()
end

if ( devicechanged['D_KODI_STOP'] == 'On' ) then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:stop()
end

if ( devicechanged['D_KODI_UP'] == 'On' ) then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:up()
end

if ( devicechanged['D_KODI_DOWN'] == 'On' ) then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:down()
end

if ( devicechanged['D_KODI_LEFT'] == 'On' ) then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:left()
end

if ( devicechanged['D_KODI_RIGHT'] == 'On' ) then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:right()
end

if ( devicechanged['D_KODI_OK'] == 'On' ) then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:select()
end

if ( devicechanged['D_KODI_BACK'] == 'On' ) then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:back()
end

if ( devicechanged['D_KODI_VIDEO_SCAN'] == 'On' ) then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:videoScan()
end

if ( devicechanged['D_KODI_AUDIO_SCAN'] == 'On' ) then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:audioScan()
end

if ( devicechanged['D_KODI_SUBTITLE'] == 'On' ) then
	kodi = Kodi.createFromConf(uservariables["config_file"])
	kodi:audioScan()
end

if ( devicechanged['D_KODI_POWER'] == 'On' ) then
	if ( otherdevices['P_KODI'] == 'On' and  otherdevices['Alim_Kodi'] == 'On') then
		kodi = Kodi.createFromConf(uservariables["config_file"])
		kodi:halt()
	elseif ( otherdevices['Alim_Kodi'] == 'Off' ) then
		command('Alim_Kodi','On')
	end
end

if (devicechanged['P_KODI'] == 'On' and uservariables["source_tv"] == 1) then
	 command('D_TV_SOURCE','On')
end	



return commandArray