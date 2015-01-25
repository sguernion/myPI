commandArray = {}

---------------------------------------------------
-- Virtual Devices : Amp_Mute,Volume default,Volume up,Volume Down,Source Bluetooth,
--                   Source Wii,Source Tuner,Source_Tv,Source Xbmc,Source Web Radio
-- User Variables : amp_mute,volume,
--
---------------------------------------------------

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'marantz_api'
require 'utils_functions'

if ( devicechanged['D_AMPLI_V_DEFAULT'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:change_volume(tostring(uservariables["volume_defaut"]-80))
	commandArray['Variable:volume'] = tostring(uservariables["volume_defaut"])
end

if ( devicechanged['D_AMPLI_V_UP'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:volume_up()
	commandArray['Variable:volume'] = tostring(uservariables["volume"] +0.5)
end

if ( devicechanged['D_AMPLI_V_DOWN'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:volume_down()
	commandArray['Variable:volume'] = tostring(uservariables["volume"] -0.5)
end

if ( devicechanged['V_VOLUME_UP'] == 'On' ) then
	commandArray['Variable:volume'] = tostring(uservariables["volume"] +0.5)
end

if ( devicechanged['V_VOLUME_DOWN'] == 'On' ) then
	commandArray['Variable:volume'] = tostring(uservariables["volume"] -0.5)
end

if ( devicechanged['D_AMPLI_S_BLUETOOTH'] == 'On' ) then
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
		commandArray['D_TV_SOURCE']='On'
	end	
end

if ( devicechanged['D_AMPLI_S_KODI'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:change_source('MPLAY')
	if (uservariables["source_tv"] == 0) then
		commandArray['D_TV_SOURCE']='On'
	end	
end

if ( devicechanged['D_AMPLI_S_WEB'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:change_source('IRADIO')
end



if ( devicechanged['P_PHONE_CALL'] == 'On' or otherdevices['D_AMPLI_MUTE'] == 'Off' ) then
	commandArray['Amp_Mute'] = devicechanged['P_PHONE_CALL']
end

if ( devicechanged['P_PHONE_CALL'] == 'Off' or otherdevices['D_AMPLI_MUTE'] == 'On' ) then
	if(uservariables["amp_mute"] == 1) then
		commandArray['Amp_Mute'] = devicechanged['P_PHONE_CALL']
	end
end

if ( devicechanged['V_MUTE'] == 'On' ) then
	if(uservariables["amp_mute"] == 1) then
		commandArray['D_AMPLI_MUTE'] = 'Off'
		commandArray['Variable:amp_mute'] = '0'
	else
		commandArray['D_AMPLI_MUTE'] = 'On'
		commandArray['Variable:amp_mute'] = '1'
	end
end



if ( devicechanged['D_AMPLI_MUTE'] == 'On' or devicechanged['D_AMPLI_MUTE'] == 'Off' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	if(uservariables["amp_mute"] == 0) then
		--print('Mute')
		commandArray['Variable:amp_mute'] = '1'
		marantz:volume_mute()
	 else
		commandArray['Variable:amp_mute'] = '0'
		--print('UnMute')
		marantz:volume_unmute()
	end
end





-- TODO

return commandArray