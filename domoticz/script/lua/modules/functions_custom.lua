package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'Properties_class'

-- custom functions

function command_scene(scene,action)
	command('Scene:'..scene,action)
end

function command_variable(variable,valeur)
	command('Variable:'..variable,tostring(valeur))
end

function command(command,action)
	commandArray[command] = action
end


function commandValue(name,value)
	local properties = Properties.create(uservariables["domoticz_file"])
	deviceIndex = properties:get('idx.'..name)
	print(name..' '..deviceIndex..' = '..tostring(value))
	commandArray['UpdateDevice'] = deviceIndex ..'|0|'.. tostring(value)
end


-- Custom implementation (mobile, motion sensors...)
function presenceAtHome()
	return presenceSmartphone() or presenceMotion()
end

-- Detect device P_Smartphone or P_Smartphone_XXX is present
function presenceSmartphone()
	return oneDeviceHasState('P_Smartphone','On')
end

-- Detect device P_MOTION or P_MOTION_XXX is present
function presenceMotion()
	return oneDeviceHasStateAfterTime('P_GENERALE_MOTION','On',300)
end



function auto()
	return otherdevices['Auto'] == 'On'
end

function absence()
	return otherdevices['Mode_Absence'] == 'On'
end

function vacances(name)
	if(name ~= nil ) then
		return otherdevices['Vacances_' .. name] == 'On'
	else
		return false
	end
end

function devicesOff()
	command_scene('DevicesOff','On')
end


-- Envoie d'un sms sur un mobile Free
-- 
--	Configuration du fichier config.properties
--	free.mobile.api.user=xxxx
--  free.mobile.api.key=xxxxxx
--
function send_sms (properties,message)
	user=properties:get('free.mobile.api.user')
	key=properties:get('free.mobile.api.key')
	commandArray['OpenURL']='https://smsapi.free-mobile.fr/sendmsg?user='..user..'&pass='..key..'&msg='..message
end


function send_vocal (message)
	os.execute('/home/pi/domoticz/scripts/sh/speak.sh ' .. message)
	os.execute('wait 10 ')
end


function irsend (command)
	os.execute('/home/pi/domoticz/scripts/sh/irSend.sh '..command)
end

function sourceTv ()
	irsend('source')
	if (uservariables["source_tv"] == 1) then
		command_variable('source_tv',0)
	else
		command_variable('source_tv',1)
	end	
end


function alert_mesure(name,max_value,properties,message)   
	if devicechanged[name] then
		mesure = tonumber(otherdevices_svalues[name])
		if mesure > max_value then
			--print(name..' : '.. tostring(mesure))
			send_sms (properties,message)
		end
	end
end

function alert_mesure(name,max_value,properties,message,cpt_name,cpt_max)  
	local cpt_alert = uservariables[cpt_name]
	if devicechanged[name] then
		mesure = tonumber(otherdevices_svalues[name])
		if( mesure > max_value and cpt_alert < cpt_max ) then
			--print(name..' : '.. tostring(mesure))
			send_sms (properties,message)
			command_variable(cpt_name,cpt_alert +1)
		end
	end
end

function domoticz_reboot(properties)
	ip=properties:get('domoticz.ip')
	port=properties:get('domoticz.port')
    os.execute('curl -s -i -H "Accept: application/json" "http://' .. ip ..':'.. port ..'/json.htm?type=command&param=system_reboot"')
end


function alimOff_AfterDeviceShutdown(device,alim_device,time_min,time_max)
		if (otherdevices[device] == 'Off' and otherdevices[alim_device] == 'On' and oneDeviceTime_difference_between(device,time_min,time_max)) then
			command(alim_device,'Off')
		end
end

---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------
function jourChome() 
	return uservariables["jourChome"] == 1
end

---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------
function veilleJourChome() 
	return uservariables["veilleJourChome"] == 1
end



