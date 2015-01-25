commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'




if ( devicechanged['D_TV_SOURCE'] == 'On' ) then
	sourceTv()
end

if ( devicechanged['D_TV_INFO'] == 'On' ) then
	irsend('KEY_INFO')
end

if ( devicechanged['D_TV_PGR_UP'] == 'On' ) then
	irsend('KEY_CHANNELUP')
end

if ( devicechanged['D_TV_PGR_DOWN'] == 'On' ) then
	irsend('KEY_CHANNELDOWN')
end

if ( devicechanged['D_TV_CH_BFM'] == 'On' ) then
	if ( devicechanged['P_TV'] == 'Off' ) then
		irsend('KEY_POWER')
	end
    -- if is not source tv
	if (uservariables["source_tv"] == 0) then
		sourceTv()
	end	
	irsend('bfmtv')
	commandArray['D_AMPLI_S_TV'] = 'On'
end


if ( devicechanged['D_TV_POWER'] == 'On' ) then
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