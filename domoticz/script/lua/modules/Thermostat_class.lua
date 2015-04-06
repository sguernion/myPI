package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'


Thermostat = {}
Thermostat.__index = Thermostat


function Thermostat.create(d_chaudiere,d_ouverture,consigne,consigne_min,var_tht_temp,hysteresis) --
	local tht = {}             -- our new object
	setmetatable(tht,Thermostat)  -- make Thermostat handle lookup
    tht.debug = isDebug()
	if(tht.debug) then
	    print ("--------- init Thermostat ------- " )
		print ("d_chaudiere:  " .. tostring(d_chaudiere))
		print ("d_ouverture:  " .. tostring(d_ouverture))
		print ("consigne:  " .. tostring(consigne))
		print ("consigne_min:  " .. tostring(consigne_min))
		print ("hysteresis:  " .. tostring(hysteresis))
		print ("var_tht_temp:  " .. tostring(var_tht_temp))
		print ("--------------------------------- " )
	end
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
	if(self.debug) then
		print ("switch ".. self.d_chaudiere .. " to  " .. cmd .." temp : ".. tostring(valeur_temp))
	end
	if(otherdevices[self.d_chaudiere]~=cmd) then
		command(self.d_chaudiere,cmd)
	end
	command_variable(self.var_tht_temp,valeur_temp)
	
end

function Thermostat:gestionChauffeManual(temperature,consigne)
	if self.debug then  print ("TERMO Manual Mode") end
	if self.debug then  print ("Temperature Setpoint for Manual Mode: "..consigne.." Celsius") end
	self:gestionChauffeByHysteresis(temperature,consigne)
end


function Thermostat:gestionChauffeByHysteresis(temperature,consigne)
	if (temperature < (consigne - self.hysteresis) and otherdevices[self.d_chaudiere]=='Off' and otherdevices[self.d_ouverture]=='Off') then
	    if self.debug then print('Allumage du chauffage') end
		self:declenchenemtChaudiere('On',consigne)
	elseif (temperature > (consigne + self.hysteresis)) then
	    if self.debug then print('Extinction du chauffage') end
		self:declenchenemtChaudiere('Off',consigne)
	end
end

function Thermostat:gestionChauffe(d_thermostat,temperature)
	if self.debug then  print ("Temperature value : "..temperature.." Celsius") end
	--On n'agit que si le "Thermostat" est actif
	if (otherdevices[d_thermostat]=='On' ) then
		if self.debug then  print ("Temperature Setpoint for Confort Mode: "..self.consigne.." Celsius") end
		self:gestionChauffeByHysteresis(temperature,self.consigne )
	elseif (otherdevices[d_thermostat]=='Off') then
		if self.debug then  print ("Temperature Setpoint for Eco Mode: "..self.consigne_min.." Celsius") end
		self:gestionChauffeByHysteresis(temperature,self.consigne_min )
	end
end