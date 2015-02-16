commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'




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

if ( oneDeviceChangeHasState('D_TV_CH_','On') ) then
	if ( devicechanged['P_TV'] == 'Off' ) then
		irsend('KEY_POWER')
	end
    -- if is not source tv
	if (uservariables["source_tv"] == 0) then
		sourceTv()
	end	
	command('D_AMPLI_S_TV','On')
end

if ( devicechanged['D_TV_CH_BFM'] == 'On' ) then	
	irsend('bfmtv')
end	


if ( devicechanged['D_TV_CH_TF1'] == 'On' ) then
	irsend('KEY_1')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_FR2'] == 'On' ) then
	irsend('KEY_2')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_FR3'] == 'On' ) then
	irsend('KEY_3')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_W9'] == 'On' ) then
	irsend('KEY_9')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_FR4'] == 'On' ) then
	irsend('KEY_1')
	irsend('KEY_4')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_M6'] == 'On' ) then
	irsend('KEY_6')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_6TER'] == 'On' ) then
	irsend('KEY_2')
	irsend('KEY_2')
	irsend('KEY_OK')
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