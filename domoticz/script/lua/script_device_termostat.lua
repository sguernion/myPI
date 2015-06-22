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
	local var_tht_temp_last_val = 'tht_temp_last_val'
	local var_tht_tendance = 'tht_tendance'
	
	local var_tht_temp_ext_last_val = 'tht_temp_ext_last_val'
	local var_tht_tendance_ext = 'tht_tendance_ext'
	local hysteresis = uservariables["tht_hysteresis"] --Valeur seuil pour éviter que le relai ne cesse de commuter dans les 2 sens
	
	
	local sonde = 'T_TH_TEMP_SALLE' --Nom de la sonde de température
	local sonde_ext = 'C_TEMP_ACIGNE' --Nom de la sonde de température exterieur
	local d_cmd_thermostat = 'T_TH_CMD_CHAUFAGE' --Nom de l'interrupteur virtuel du thermostat
	local d_ouverture = 'Ouverture' --Non de l'interrupteur qui indique si une ouverture est ouverte
	local d_chaudiere = 'T_TH_CHAUFFAGE' --Nom de la chaudière à allumer/éteindre
	local deviceauto = 'T_TH_AUTO' -- mode chauffage auto
	local d_thermostat = 'T_TH_MARCHE' -- thermostat activé
	--------------------------------
	-- Fin des variables à éditer --
	--------------------------------
	
	function tempTendance(temp_sonde,var_tht_temp_last_val,var_tht_tendance)
		if (devicechanged[temp_sonde]) then
			local temperature = tonumber(string.sub(devicechanged[string.format('%s_Temperature', temp_sonde)],0,6)) --Temperature relevée
			-- calculer l'augmentation ou la baisse de temp sur une fenetre de 5 min
			last_value = uservariables[var_tht_temp_last_val];
			last_value_update = (tonumber(getHourVar(var_tht_temp_last_val))*60) + tonumber(getMinuteVar(var_tht_temp_last_val))
			local today_min= (tonumber(os.date("%H"))*60)+tonumber(os.date("%M"))
			if((today_min - last_value_update) >= 5 ) then 
				print('tendance'..temperature.. ' last :'..last_value..' '..getTimeVar(var_tht_temp_last_val)) 
				if ( last_value > temperature ) then command_variable(var_tht_tendance,''..(temperature-last_value)) end
				if ( temperature > last_value ) then command_variable(var_tht_tendance,'+'..(temperature-last_value)) end
				if ( last_value == temperature ) then command_variable(var_tht_tendance,'=0') end
				command_variable(var_tht_temp_last_val,temperature)
			end
		end	 
	end
	
	tempTendance(sonde,var_tht_temp_last_val,var_tht_tendance)
	tempTendance(sonde_ext,var_tht_temp_ext_last_val,var_tht_tendance_ext)
	
	if(otherdevices[d_thermostat] == 'On') then
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
	end
	
	

	
return commandArray
