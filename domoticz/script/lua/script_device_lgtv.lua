commandArray = {}



if ( devicechanged['TV_SOURCE'] == 'On' ) then
	os.execute('/home/pi/domoticz/scripts/irSend.sh source')
end

if ( devicechanged['TV_INFO'] == 'On' ) then
    -- TODO if is not source tv
	--os.execute('/home/pi/domoticz/scripts/irSend.sh source')
	os.execute('/home/pi/domoticz/scripts/irSend.sh bfmtv')
	commandArray['Source_Tv'] = 'On'
end

if ( devicechanged['TV_POWER'] == 'On' ) then
	os.execute('/home/pi/domoticz/scripts/irSend.sh KEY_POWER')
end

-- TODO

return commandArray