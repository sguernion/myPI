commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'marantz_api'

if ( devicechanged['Volume default'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:change_volume(tostring(uservariables["volume_defaut"]-80))
	commandArray['Variable:volume'] = tostring(uservariables["volume_defaut"])
end

if ( devicechanged['Volume up'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:volume_up()
	commandArray['Variable:volume'] = tostring(uservariables["volume"] +0.5)
end

if ( devicechanged['Volume Down'] == 'On' ) then
	marantz = Marantz.createFromConf(uservariables["config_file"])
	marantz:volume_down()
	commandArray['Variable:volume'] = tostring(uservariables["volume"] -0.5)
end

if ( devicechanged['Amp_Mute'] == 'On' or devicechanged['Amp_Mute'] == 'Off' ) then
	if(uservariables["amp_mute"] == 0) then
		commandArray['Variable:amp_mute'] = '1'
	 else
		commandArray['Variable:amp_mute'] = '0'
	end
end



-- TODO

return commandArray