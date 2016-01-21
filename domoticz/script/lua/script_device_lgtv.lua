commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'

local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

function power()
	if ( otherdevices['P_TV'] == 'Off' ) then
		irsend('KEY_POWER')
		command('P_TV','On')
	end
end

if ( devicechanged['D_TV_SOURCE'] == 'On' ) then
	sourceTv()
end

if ( devicechanged['D_TV_INFO'] == 'On' ) then
	power()
	irsend('KEY_INFO')
end

if ( devicechanged['D_TV_PGRUP'] == 'On' ) then
	irsend('KEY_CHANNELUP')
end

if ( devicechanged['D_TV_PGRDOWN'] == 'On' ) then
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
	power()
	command_variable('ch_tv','BFM')
	irsend('bfmtv')
end	


if ( devicechanged['D_TV_CH_TF1'] == 'On' ) then
	power()
	command_variable('ch_tv','TF1')
	irsend('KEY_1')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_FR2'] == 'On' ) then
	power()
	command_variable('ch_tv','FR2')
	irsend('KEY_2')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_FR3'] == 'On' ) then
	power()
	command_variable('ch_tv','FR3')
	irsend('KEY_3')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_W9'] == 'On' ) then
	power()
	command_variable('ch_tv','W9')
	irsend('KEY_9')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_FR4'] == 'On' ) then
	power()
	command_variable('ch_tv','FR4')
	irsend('KEY_1')
	irsend('KEY_4')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_M6'] == 'On' ) then
	power()
	command_variable('ch_tv','M6')
	irsend('KEY_6')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_CH_6TER'] == 'On' ) then
	power()
	command_variable('ch_tv','6TER')
	irsend('KEY_2')
	irsend('KEY_2')
	irsend('KEY_OK')
end

if ( devicechanged['D_TV_POWER'] == 'On' ) then
	power()
end

if ( devicechanged['D_TV_POWER_OFF'] == 'On' ) then
	if ( otherdevices['P_TV'] == 'On' ) then
		irsend('KEY_POWER')
		command('P_TV','Off')
	end
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