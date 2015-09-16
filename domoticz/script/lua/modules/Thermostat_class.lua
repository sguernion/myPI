package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'


Thermostat = {}
Thermostat.__index = Thermostat


function Thermostat.create(d_chaudiere,d_ouverture,consigne,consigne_min,var_tht_temp,hysteresis) --
	local tht = {}             -- our new object
	setmetatable(tht,Thermostat)  -- make Thermostat handle lookup
	LOG:debug ("--------- init Thermostat ------- " )
	LOG:debug ("d_chaudiere:  " .. tostring(d_chaudiere))
	LOG:debug ("d_ouverture:  " .. tostring(d_ouverture))
	LOG:debug ("consigne:  " .. tostring(consigne))
	LOG:debug ("consigne_min:  " .. tostring(consigne_min))
	LOG:debug ("hysteresis:  " .. tostring(hysteresis))
	LOG:debug ("var_tht_temp:  " .. tostring(var_tht_temp))
	LOG:debug ("--------------------------------- " )
    tht.d_chaudiere = d_chaudiere
	tht.d_ouverture = d_ouverture
	tht.consigne = consigne
	tht.consigne_min = consigne_min
	tht.hysteresis = hysteresis
	tht.var_tht_temp = var_tht_temp
	return tht
end

---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------
function Thermostat:declenchenemtChaudiere(cmd,valeur_temp)
	LOG:debug ("switch ".. self.d_chaudiere .. " to  " .. cmd .." temp : ".. tostring(valeur_temp))
	if(otherdevices[self.d_chaudiere]~=cmd) then
		command(self.d_chaudiere,cmd)
	end
	command_variable(self.var_tht_temp,valeur_temp)
	
end

function Thermostat:gestionChauffeManual(temperature,consigne)
	LOG:debug("TERMO Manual Mode")
	LOG:debug("Temperature Setpoint for Manual Mode: "..consigne.." Celsius")
	self:gestionChauffeByHysteresis(temperature,consigne)
end


function Thermostat:gestionChauffeByHysteresis(temperature,consigne)
	if (temperature < (consigne - self.hysteresis) and otherdevices[self.d_chaudiere]=='Off' and otherdevices[self.d_ouverture]=='Off') then
	    LOG:debug('Allumage du chauffage')
		self:declenchenemtChaudiere('On',consigne)
	elseif (temperature > (consigne + self.hysteresis)) then
	    LOG:debug('Extinction du chauffage')
		self:declenchenemtChaudiere('Off',consigne)
	end
end

function Thermostat:gestionChauffe(d_thermostat,temperature)
	LOG:debug("Temperature value : "..temperature.." Celsius")
	--On n'agit que si le "Thermostat" est actif
	if (otherdevices[d_thermostat]=='On' ) then
		LOG:debug("Temperature Setpoint for Confort Mode: "..self.consigne.." Celsius")
		self:gestionChauffeByHysteresis(temperature,self.consigne )
	elseif (otherdevices[d_thermostat]=='Off') then
		LOG:debug("Temperature Setpoint for Eco Mode: "..self.consigne_min.." Celsius")
		self:gestionChauffeByHysteresis(temperature,self.consigne_min )
	end
end

	function tempTendance(temp_sonde,tht_temp_last_val,tht_tendance)
		if (devicechanged[temp_sonde]) then
			local temperature = getTemperature(temp_sonde) --Temperature relevée
			-- calculer l'augmentation ou la baisse de temp sur une fenetre de 5 min
			last_value = uservariables[tht_temp_last_val];
			last_value_update = toMinute(getHourVar(tht_temp_last_val),getMinuteVar(tht_temp_last_val))

			local today_min= toMinute(os.date("%H"),os.date("%M"))
			if(((today_min - last_value_update) >= 5 ) or ((today_min - last_value_update) < 0 ) ) then 
				LOG:debug('tendance'..temperature.. ' last :'..last_value..' '..getTimeVar(tht_temp_last_val)) 
				if ( last_value > temperature ) then command_variable(tht_tendance,''..(temperature-last_value)) end
				if ( temperature > last_value ) then command_variable(tht_tendance,'+'..(temperature-last_value)) end
				if ( last_value == temperature ) then command_variable(tht_tendance,'=0') end
				command_variable(tht_temp_last_val,temperature)
			end
		end	 
	end


