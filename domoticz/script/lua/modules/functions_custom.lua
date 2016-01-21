package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'Properties_class'
require 'Domoticz_class'


------------------------------------------------------------------------------------------
--
--                 commands Functions
--
------------------------------------------------------------------------------------------
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
	LOG:debug(name..' '..deviceIndex..' = '..tostring(value))
	commandArray['UpdateDevice'] = deviceIndex ..'|0|'.. tostring(value)
end


------------------------------------------------------------------------------------------
--
--                 custom Functions
--
------------------------------------------------------------------------------------------
-- Custom implementation (mobile, motion sensors...)
function presenceAtHome()
	return presenceSmartphone() or presenceMotion()
end

-- Detect device P_Smartphone or P_Smartphone_XXX is present
function presenceSmartphone()
	return oneDeviceHasState('P_Smartphone','On')
end

-- Detect device P_GENERALE_MOTION is present
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

function allOff()
	command_scene('DevicesOff','On')
	command_scene('Eclairage_Off','On')
end



------------------------------------------------------------------------------------------
--
--                 Notification/Alerts Functions
--
------------------------------------------------------------------------------------------
function alert_mesure(name,max_value,message)   
	if devicechanged[name] then
		mesure = tonumber(otherdevices_svalues[name])
		if mesure > max_value then
			--print(name..' : '.. tostring(mesure))
			send_sms (message:gsub("{0}", mesure))
		end
	end
end

function alert_mesure(name,max_value,message,cpt_name,cpt_max)  
	local cpt_alert = uservariables[cpt_name]
	if devicechanged[name] then
		mesure = tonumber(otherdevices_svalues[name])
		if( mesure > max_value and cpt_alert < cpt_max ) then
			--print(name..' : '.. tostring(mesure))
			send_sms (message:gsub("{0}", mesure))
			command_variable(cpt_name,cpt_alert +1)
		end
	end
	
	local today=os.date("%Y-%m-%d")
	if( today ~= string.sub(uservariables_lastupdate[cpt_name],0,10) and cpt_alert > cpt_max ) then
		command_variable(cpt_name,0)
	end
end

-- Envoie d'un sms sur un mobile Free
-- 
--	Configuration du fichier config.properties
--	free.mobile.api.user=xxxx
--  free.mobile.api.key=xxxxxx
--
function send_sms (message)
	local properties = Properties.create(uservariables["config_file"])
	user=properties:get('free.mobile.api.user')
	key=properties:get('free.mobile.api.key')
	commandArray['OpenURL']='https://smsapi.free-mobile.fr/sendmsg?user='..user..'&pass='..key..'&msg='..message
end



---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------
function jourChome() 
	return uservariables["jourChome"] == 1
end


function veilleJourChome() 
	return uservariables["veilleJourChome"] == 1
end



---------------------------------------------------------------------------
--                                                                       --
--                          Others functions                             --
--                                                                       --
---------------------------------------------------------------------------
function alimOff_AfterDeviceShutdown(device,alim_device,time_min,time_max)
		if (otherdevices[device] == 'Off' and otherdevices[alim_device] == 'On' and oneDeviceTime_difference_between(device,time_min,time_max)) then
			command(alim_device,'Off')
		end
end


function send_vocal (message)
	os.execute('/home/pi/domoticz/scripts/sh/speak.sh ' .. message)
	os.execute('wait 10 ')
end


function irsend (remote, command)
	os.execute('/home/pi/domoticz/scripts/sh/irSend.sh '..remote..' '..command)
end


function sourceTv ()
	irsend('lgtv','source')
	command('V_SOURCE','On')
end

