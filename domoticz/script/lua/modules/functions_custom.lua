package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'

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
	return oneDeviceHasState('P_MOTION','On')
end



function auto()
	return otherdevices['Auto'] == 'On'
end

function absence()
	return otherdevices['Mode_Absence'] == 'On'
end

function vacances(name)
	return otherdevices['Vacances_' .. name] == 'On'
end

function devicesOff()
	command_scene('DevicesOff','On')
end

-- 
-- Envoie d'un sms sur un mobile Free
function send_sms (user,key,message)
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


function alert_mesure(name,max_value,user,key,message)   
	if devicechanged[name] then
		mesure = tonumber(otherdevices_svalues[name])
		if mesure > max_value then
			print(name..' : '.. tostring(mesure))
			send_sms (user,key,message)
		end
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



