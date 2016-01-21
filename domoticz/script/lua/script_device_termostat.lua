commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Thermostat_class'
require 'Domoticz_class'

----------------------------------------------
------Thermostat nonoZone par Hysteresis------
----------------------------------------------
	
	
	-------------------------------------
	------ création des Variables  ------
	-------------------------------------
    local Domoticz = Domoticz.createFromConf(uservariables["config_file"])
	-- tht_cons_confort : 20
	--Domoticz:addVariable(1,'tht_cons_confort','20')
	-- tht_cons_eco : 17
	--Domoticz:addVariable(1,'tht_cons_eco','17')
	-- tht_cons_hors_gel : 15
	--Domoticz:addVariable(1,'tht_cons_hors_gel','15')
	-- tht_manual : 20
	--Domoticz:addVariable(1,'tht_manual','20')
	-- tht_temperature : 20
	--Domoticz:addVariable(1,'tht_temperature','20')
	-- tht_hysteresis = 0.5
	--Domoticz:addVariable(1,'tht_hysteresis','0.5')
	
	--Domoticz:addVariable(1,'tht_temp_ext_last_val','20')
	--Domoticz:addVariable(2,'tht_tendance_ext','=0')
	--Domoticz:addVariable(1,'tht_temp_last_val','20')
	--Domoticz:addVariable(2,'tht_tendance','=0')
	--------------------------------
	------ Variables à éditer ------
	--------------------------------
	
	local consigne = uservariables["tht_cons_confort"]  --Température de consigne
	local consigne_min = uservariables["tht_cons_eco"]  --Température minimum
	local consigne_hors_gel = uservariables["tht_cons_hors_gel"]
	local manual_temp = uservariables["tht_manual"]
	local var_tht_temp = 'tht_temperature'
	
	local d_tendance_ext = 'T_TENDANCE_ACIGNE'
	local hysteresis = uservariables["tht_hysteresis"] --Valeur seuil pour éviter que le relai ne cesse de commuter dans les 2 sens
	
	
	local sonde = 'T_TH_TEMP_PALIER' --Nom de la sonde de température
	local sonde_ext = 'C_TEMP_ACIGNE' --Nom de la sonde de température exterieur
	local d_cmd_thermostat = 'T_TH_CMD_CHAUFAGE' --Nom de l'interrupteur virtuel du thermostat
	local d_ouverture = 'Ouverture' --Non de l'interrupteur qui indique si une ouverture est ouverte
	local d_chaudiere = 'T_TH_CHAUFFAGE' --Nom de la chaudière à allumer/éteindre
	local deviceauto = 'T_TH_AUTO' -- mode chauffage auto
	local d_thermostat = 'T_TH_MARCHE' -- thermostat activé
	--------------------------------
	-- Fin des variables à éditer --
	--------------------------------


	--------------------------------------------------------------------------
	--         Conseil grace aux tendances                                 ---
	--------------------------------------------------------------------------

	if (devicechanged[temp_sonde] and otherdevices[d_thermostat] == 'On') then
		local temperature_ext = getTemperature( sonde_ext)
		local temperature_int = getTemperature(sonde)
	 	-- si tendance ext(+2) and temp_ext > temp_int alors alert('augmentation de la temps, pensé a fermer les volets')
	 	if (temperature_ext > temperature_int and otherdevices[d_tendance_ext] == "+2") then 
			LOG:info("augmentation de la temps, pensé a fermer les volets")
		end
	 	-- si tendance ext(-2) and temp_ext < temp_int alors alert('diminution de la temps, pensé a ouvrir les fenetres')
		if (temperature_ext < temperature_int and otherdevices[d_tendance_ext] == "-2") then 
			LOG:info("diminution de la temps, pensé a ouvrir les fenetres")
		end
	end

	--------------------------------------------------------------------------
	--------------------------------------------------------------------------

	if(otherdevices[d_thermostat] == 'On') then
		--La sonde Oregon 'thermostat' emet toutes les 40 secondes. Ce sera approximativement la fréquence 
		-- d'exécution de ce script.
		if (devicechanged[sonde]) then
			local thermostat = Thermostat.create(d_chaudiere,d_ouverture,consigne,consigne_min,var_tht_temp,hysteresis)
	
			local temperature = getTemperature(sonde) --Temperature relevée
		    
			if (otherdevices[deviceauto] == 'Off') then
				thermostat:gestionChauffeManual(temperature,manual_temp )
			else
				thermostat:gestionChauffe(d_cmd_thermostat,temperature )
			end
		end
	end
	
	

	
return commandArray
