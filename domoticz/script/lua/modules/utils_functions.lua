
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


-- calcul du temps en seconde depuis la derniere mise a jour du capteur
function time_difference (device)
	t1 = os.time()
	return basetime_difference (t1,device)
end

function basetime_difference (t1,device)
	t1 = os.time()
	s = otherdevices_lastupdate[device]
	-- returns a date time like 2013-07-11 17:23:12

	year = string.sub(s, 1, 4)
	month = string.sub(s, 6, 7)
	day = string.sub(s, 9, 10)
	hour = string.sub(s, 12, 13)
	minutes = string.sub(s, 15, 16)
	seconds = string.sub(s, 18, 19)


	t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
	return (os.difftime (t1, t2))
end

function oneDeviceChangeHasState(devicePrefix,state)
	present = false
	for i, v in pairs(devicechanged) do
		tc = tostring(i)
		if (tc:sub(1,devicePrefix:len()) == devicePrefix) then
			if(otherdevices[tc] == state) then
				present = true
			end
		end
	end
	return present
end

function oneDeviceHasState(devicePrefix,state)
	present = false
	for i, v in pairs(otherdevices) do
		tc = tostring(i)
		
		if (tc:sub(1,devicePrefix:len()) == devicePrefix) then
			--print(tc:sub(1,devicePrefix:len()) ..' '..devicePrefix.. ' '..v)
			if(otherdevices[tc] == state) then
			--print(tc:sub(1,devicePrefix:len()) ..' '..devicePrefix.. ' '..v)
			present = true
		end
		end
	end
	return present
end

function oneDeviceHasStateAfterTime(devicePrefix,state,diffTime)
	present = false
	for i, v in pairs(otherdevices) do
		tc = tostring(i)
		v = i:sub(1,state:len())
		difference = time_difference(tc)
		if (tc:sub(1,devicePrefix:len()) == devicePrefix ) then
			if(otherdevices[tc] == state and difference > diffTime) then
				present = true
			end
		end
	end
	return present
end

function oneDeviceHasStateAfterBaseTime(devicePrefix,state,baseTime,diffTime)
	present = false
	for i, v in pairs(otherdevices) do
		tc = tostring(i)
		v = i:sub(1,state:len())
		difference = time_difference(tc)
		if (tc:sub(1,devicePrefix:len()) == devicePrefix ) then
			if(otherdevices[tc] == state and difference > diffTime) then
				present = true
			end
		end
	end
	return present
end

function oneDeviceHasStateBetweenTime(devicePrefix,state,diffStart,diffEnd)
	present = false
	for i, v in pairs(otherdevices) do
		tc = tostring(i)
		v = i:sub(1,state:len())
		difference = time_difference(tc)
		if (tc:sub(1,devicePrefix:len()) == devicePrefix ) then
			if(otherdevices[tc] == state and difference > diffStart and difference < diffEnd) then
				present = true
			end
		end
	end
	return present
end


 function ping_alive (device,ip)
	if (ip  ~= nil and ip  ~= '') then
		 ping_success=os.execute('ping -c1 ' .. ip)
		 if ping_success then
			if ( otherdevices[device] == 'Off') then
				commandArray[device]='On'
			end
		 else
		  if (otherdevices[device] == 'On') then
			commandArray[device]='Off'
		  end
		 end
	else
		print(" ip null for device ".. device )
	end
end
 

-- domoticz functions

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

-- Detect device P_Motion or P_Motion_XXX is present
function presenceMotion()
	return oneDeviceHasState('P_Motion','On')
end



function auto()
	return otherdevices['Auto'] == 'On'
end

function absence()
	return otherdevices['Mode_Absence'] == 'On'
end

function vacances(name)
	return otherdevices['Vacances_'..name] == 'On'
end

function devicesOff()
	command_scene('DevicesOff','On')
end


function sourceTv ()
	irsend('source')
	if (uservariables["source_tv"] == 1) then
		command_variable('source_tv',0)
	else
		command_variable('source_tv',1)
	end	
end