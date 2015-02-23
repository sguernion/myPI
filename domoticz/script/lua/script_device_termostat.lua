commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Thermostat_class'

----------------------------------------------
------Thermostat nonoZone par Hysteresis------
----------------------------------------------
	
	
	--------------------------------
	------ Variables à créer  ------
	--------------------------------
	-- tht_cons_confort : 20
	-- tht_cons_eco : 17
	-- tht_cons_hors_gel : 15
	-- tht_manual : 20
	-- tht_temperature : 20
	-- tht_hysteresis = 0.5
	--------------------------------
	------ Variables à éditer ------
	--------------------------------
	
	local consigne = uservariables["tht_cons_confort"]  --Température de consigne
	local consigne_min = uservariables["tht_cons_eco"]  --Température minimum
	local consigne_hors_gel = uservariables["tht_cons_hors_gel"]
	local manual_temp = uservariables["tht_manual"]
	local var_tht_temp = 'tht_temperature'
	local hysteresis = uservariables["tht_hysteresis"] --Valeur seuil pour éviter que le relai ne cesse de commuter dans les 2 sens
	
	
	local sonde = 'T_TH_TEMP_PALIER' --Nom de la sonde de température
	local d_cmd_thermostat = 'T_TH_CMD_CHAUFAGE' --Nom de l'interrupteur virtuel du thermostat
	local d_ouverture = 'Ouverture' --Non de l'interrupteur qui indique si une ouverture est ouverte
	local d_chaudiere = 'T_TH_CHAUFFAGE' --Nom de la chaudière à allumer/éteindre
	local deviceauto = 'T_TH_AUTO' -- mode chauffage auto
	--------------------------------
	-- Fin des variables à éditer --
	--------------------------------
	
	
	
	--La sonde Oregon 'thermostat' emet toutes les 40 secondes. Ce sera approximativement la fréquence 
	-- d'exécution de ce script.
	if (devicechanged[sonde]) then
		local thermostat = Thermostat.create(d_chaudiere,d_ouverture,consigne,consigne_min,var_tht_temp,hysteresis)
	
		local temperature = devicechanged[string.format('%s_Temperature', sonde)] --Temperature relevée
	    
		if (otherdevices[deviceauto] == 'Off') then
			thermostat:gestionChauffeManual(temperature,manual_temp )
		else
			thermostat:gestionChauffe(d_cmd_thermostat,temperature )
		end
	end
	
	

	
return commandArray