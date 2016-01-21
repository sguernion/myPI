

function to_seconde (minute)
	return minute * 60
end


function to_moctet (octet)
	return ( octet / 1024 ) / 1024
end

function time_difference_between (device,delai_min,delai_max)
	difference = basetime_difference (device)
	return difference > delai_min and difference < delai_max
end

function oneDeviceTime_difference_between(devicePrefix,delai_min,delai_max)
	match = false
	for i, v in pairs(otherdevices) do
		tc = tostring(i)
		
		if (tc:sub(1,devicePrefix:len()) == devicePrefix and match == false) then
				match = time_difference_between (tc,delai_min,delai_max)
		end
	end
	return match
end

-- calcul du temps en seconde depuis la derniere mise a jour du capteur
function time_difference (device)
	return basetime_difference (device)
end

function basetime_difference (device)
	t1 = os.time()
	s = otherdevices_lastupdate[device]
	-- returns a date time like 2013-07-11 17:23:12
	return tdifference (t1,s)
end

function tdifference (t1,s)
	if(s)then
		year = string.sub(s, 1, 4)
		month = string.sub(s, 6, 7)
		day = string.sub(s, 9, 10)
		hour = string.sub(s, 12, 13)
		minutes = string.sub(s, 15, 16)
		seconds = string.sub(s, 18, 19)


		t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
		return (os.difftime (t1, t2))
	else
		return 0
	end
end


function heure_difference (uservariable)
	t1 = os.time()
	h = uservariables[uservariable]
	-- returns a date time like 17:23

	hour = string.sub(s, 1, 2)
	minutes = string.sub(s, 4, 6)



	t2 = os.time{year=tonumber(os.date('%Y',t1)), month=tonumber(os.date('%m',t1)), day=tonumber(os.date('%d',t1)), hour=hour, min=minutes}
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




function initSaison()
	time=os.time()
	isDay=os.date('%m-%d',time)
	if( isDay == "12-21" ) then
		command_variable('saison','Hiver')
	end
	if( isDay == "09-21" ) then
		command_variable('saison','Automne')
	end
	if( isDay == "03-21" ) then
		command_variable('saison','Printemps')
	end
	if( isDay == "06-21" ) then
		command_variable('saison','Ete')
	end
	 --test conditions
	if( isDay == "02-04" ) then
		command_variable('saison','Hiver')
	end

end


function saison() 
	return uservariables["saison"]
end

function isDebug() 
	if (uservariables['SCRIPTS_DEBUG']=="false") then
		return false
	else
		 return true
	end
end

function mqtt_enable() 
	if (uservariables['mqtt_enable']=="false") then
		return false
	else
		 return true
	end
end

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function getDayVar(var_name) 
	return string.sub(uservariables_lastupdate[var_name],0,10)
end

function getTimeVar(var_name) 
	return string.sub(uservariables_lastupdate[var_name],12,19)
end

function getHourVar(var_name) 
	return string.sub(uservariables_lastupdate[var_name],12,13)
end

function getMinuteVar(var_name) 
	return string.sub(uservariables_lastupdate[var_name],15,16)
end
