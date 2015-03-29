commandArray = {}

---------------------------------------------------
-- Virtual Devices : Amp_Mute,Volume default,Volume up,Volume Down,Source Bluetooth,
--                   Source Wii,Source Tuner,Source_Tv,Source Xbmc,Source Web Radio
-- User Variables : amp_mute,volume,
--
---------------------------------------------------

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'Marantz_class'
require 'functions_utils'
require 'functions_custom'

local db_max = 80
local vol_inc = 0.5

if ( devicechanged['D_AMPLI_V_DEFAULT'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:change_volume(tostring(uservariables["volume_defaut"]-db_max))
	command_variable('volume',uservariables["volume_defaut"])
	command('VOLUME',tostring(uservariables["volume_defaut"]-db_max))
end

if ( devicechanged['D_AMPLI_VUP'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:volume_up()
	command_variable('volume',uservariables["volume"] +vol_inc)
	command('VOLUME',tostring(uservariables["volume"] +vol_inc-db_max))
end

if ( devicechanged['D_AMPLI_VDOWN'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:volume_down()
	command_variable('volume',uservariables["volume"] -vol_inc)
	command('VOLUME',tostring(uservariables["volume"] -vol_inc-db_max))
end

if ( devicechanged['V_VOLUMEUP'] == 'On' ) then
	command_variable('volume',uservariables["volume"] +vol_inc)
end

if ( devicechanged['V_VOLUMEDOWN'] == 'On' ) then
	command_variable('volume',uservariables["volume"] -vol_inc)
end

if ( devicechanged['D_AMPLI_S_BTH'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:change_source('SAT/CBL')
end

if ( devicechanged['D_AMPLI_S_WII'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:change_source('DVD')
end

if ( devicechanged['D_AMPLI_S_TUNER'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:change_source('TUNER')
end

if ( devicechanged['D_AMPLI_S_TV'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:change_source('TV')
	if (uservariables["source_tv"] == 0) then
		command('D_TV_SOURCE','On')
	end	
end

if ( devicechanged['D_AMPLI_S_KODI'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:change_source('MPLAY')
	if (uservariables["source_tv"] == 0) then
		command('D_TV_SOURCE','On')
	end	
end

if ( devicechanged['D_AMPLI_S_WEB'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:change_source('IRADIO')
end

if ( devicechanged['D_AMPLI_POWER'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	if(otherdevices['P_AMPLI'] == 'Off') then
		marantz:power_on()
		command('P_AMPLI','Off')
	else
		marantz:power_off()
	end
	
end



if ( devicechanged['P_PHONE_CALL'] == 'On' or otherdevices['D_AMPLI_MUTE'] == 'Off' ) then
	command('D_AMPLI_MUTE',devicechanged['P_PHONE_CALL'])
end

if ( devicechanged['P_PHONE_CALL'] == 'Off' or otherdevices['D_AMPLI_MUTE'] == 'On' ) then
	if(uservariables["amp_mute"] == 1) then
		command('D_AMPLI_MUTE',devicechanged['P_PHONE_CALL'])
	end
end

if ( devicechanged['V_MUTE'] == 'On' ) then
	if(uservariables["amp_mute"] == 1) then
		command('D_AMPLI_MUTE','Off')
		command_variable('amp_mute',0)
	else
		command('D_AMPLI_MUTE','On')
		command_variable('amp_mute',1)
	end
end



if ( devicechanged['D_AMPLI_MUTE'] == 'On' or devicechanged['D_AMPLI_MUTE'] == 'Off' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	if(uservariables["amp_mute"] == 0) then
		--print('Mute')
		command_variable('amp_mute',1)
		marantz:volume_mute()
	 else
		command_variable('amp_mute',0)
		--print('UnMute')
		marantz:volume_unmute()
	end
end





-- TODO

return commandArray