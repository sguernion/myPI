commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'


if ( devicechanged['D_TV_SOURCE'] == 'On' ) then
	sourceTv()
end

if ( oneDeviceChangeHasState('D_TV_','On') ) then
	if ( otherdevices['P_TV'] == 'Off' ) then
		if ( otherdevices['Alim_TV'] == 'Off' ) then
			command('Alim_TV','On')
			command('P_TV','On')
		else
			irsend('KEY_POWER')
			command('P_TV','On')
		end
	end
end

if ( oneDeviceChangeHasState('D_TV_CH_','On') ) then
    -- if is not source tv
	if (uservariables["source_tv"] == 0) then
		sourceTv()
	end	
	-- Save chaine
	prefix_ch_tv = 'D_TV_CH_'
	for i, v in pairs(devicechanged) do
		tc = tostring(i)
		if (tc:sub(1,prefix_ch_tv:len()) == prefix_ch_tv) then
			if(otherdevices[tc] == 'On') then
				command_variable('ch_tv',tc:sub(prefix_ch_tv:len()+1,tc:len()))
			end
		end
	end
	-- switch ampli source tv
	--command('D_AMPLI_S_TV','On')
end

if ( devicechanged['V_SOURCE'] == 'On' ) then
	if (uservariables["source_tv"] == 1) then
		command_variable('source_tv',0)
	else
		command_variable('source_tv',1)
	end	
end

return commandArray