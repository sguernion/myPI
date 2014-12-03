commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'




if ( devicechanged['TV_SOURCE'] == 'On' ) then
	sourceTv()
end

if ( devicechanged['TV_INFO'] == 'On' ) then
	irsend('KEY_INFO')
end

if ( devicechanged['TV_PGR_UP'] == 'On' ) then
	irsend('KEY_CHANNELUP')
end

if ( devicechanged['TV_PGR_DOWN'] == 'On' ) then
	irsend('KEY_CHANNELDOWN')
end

if ( devicechanged['TV_BFM'] == 'On' ) then
	if ( devicechanged['P_Tv'] == 'Off' ) then
		irsend('KEY_POWER')
	end
    -- if is not source tv
	if (uservariables["source_tv"] == 0) then
		sourceTv()
	end	
	irsend('bfmtv')
	commandArray['Source_Tv'] = 'On'
end


if ( devicechanged['TV_POWER'] == 'On' ) then
	irsend('KEY_POWER')
end

if ( devicechanged['V_SOURCE'] == 'On' ) then
	if (uservariables["source_tv"] == 1) then
		command_variable('source_tv',0)
	else
		command_variable('source_tv',1)
	end	
end

-- TODO

return commandArray