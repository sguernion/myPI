
-- 
-- Envoie d'un sms sur un mobile Free
function send_sms (user,key,message)
	commandArray['OpenURL']='https://smsapi.free-mobile.fr/sendmsg?user='..user..'&pass='..key..'&msg='..message
end


function send_vocal (message)
	os.execute('./speak.sh ' .. message)
	os.execute('wait 10 ')
end


-- calcul du temps en seconde depuis la derniere mise a jour du capteur
function time_difference (device)
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
	return otherdevices['Smartphone'] == 'On'
end

function auto()
	return otherdevices['Auto'] == 'On'
end

function absence()
	return otherdevices['Mode_Absence'] == 'On'
end

function devicesOff()
    print('Turning off all device')
	commandArray['Scene:DevicesOff']='On'
	commandArray['Chevet']='Off'
end