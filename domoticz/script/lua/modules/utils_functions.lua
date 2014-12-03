
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
	return otherdevices['P_Smartphone'] == 'On'
end

function auto()
	return otherdevices['Auto'] == 'On'
end

function absence()
	return otherdevices['Mode_Absence'] == 'On'
end

function vacances()
	return otherdevices['Vacances'] == 'On'
end

function devicesOff()
    print('Turning off all device')
	commandArray['Scene:DevicesOff']='On'
	--commandArray['Chevet']='Off'
end



function decalage_coucher_fin_films (kodi_play_dur_name,heure_coucher_dec_name,heure_unset)
	if (uservariables[kodi_play_dur_name] == heure_unset ) then
		-- aucun decalage, reset heure coucher
		-- seulement si on a paas dépaassé l'heure de couché
		t_minutes=tonumber(os.date('%M',os.time()))
 		hours=tonumber(os.date('%H',os.time()))
 		nhour =  tonumber(string.sub(uservariables["heure_coucher"], 0, 2))
 		nminutes =  tonumber(string.sub(uservariables["heure_coucher"], 4, 5))
 		nhour_R =  tonumber(string.sub(uservariables["heure_reveil"], 0, 2))
 
 		
 		if(hours >= nhour) then 
 			if(t_minutes >= nminutes) then 
 				sminutes = tostring(nminutes+2)
 				shour = tostring(nhour)
 				command_variable(heure_coucher_dec_name,shour..':'..sminutes)
 			end
 		end
 		
 		if(hours < nhour_R) then 
 			sminutes = tostring(nminutes+2)
 			shour = tostring(nhour)
 			command_variable(heure_coucher_dec_name,shour..':'..sminutes)
 		end
		command_variable(heure_coucher_dec_name,uservariables["heure_coucher"])
	else 
		t_minutes=tonumber(os.date('%M',time)) + 3
		hours=tonumber(os.date('%H',time))
		nhour = hours + tonumber(string.sub(uservariables[kodi_play_dur_name], 0, 2))
		nminutes = t_minutes + tonumber(string.sub(uservariables[kodi_play_dur_name], 4, 5))
		if( nminutes > 60 ) then 
			nhour = nhour+1
			nminutes = nminutes -60
		end
		if( nhour > 23 ) then 
			nhour = nhour-23
		end
		
		sminutes = tostring(nminutes)
		if( nminutes < 10 ) then 
			sminutes = '0'..sminutes
		end
		
		shour = tostring(nhour)
		if( nhour < 10 ) then 
			shour = '0'..shour
		end
		
		--print(tostring(nhour)..':'..tostring(nminutes))
		command_variable(heure_coucher_dec_name,shour..':'..sminutes)
	end
end



function sourceTv ()
	irsend('source')
	if (uservariables["source_tv"] == 1) then
		command_variable('source_tv',0)
	else
		command_variable('source_tv',1)
	end	
end