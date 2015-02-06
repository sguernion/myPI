	--------------------------------
	------ Variables à créer  ------
	--------------------------------
	if(uservariables["tht_cons_confort"] == '' )then commandArray['Variable:tht_cons_confort'] = '20'end
	if(uservariables["tht_cons_eco"] == '' )then commandArray['Variable:tht_cons_eco'] = '17.5'end
	if(uservariables["tht_cons_hors_gel"] == '' )then commandArray['Variable:tht_cons_hors_gel'] = '15'end
	if(uservariables["tht_temperature"] == '' )then commandArray['Variable:tht_temperature'] = '20'end
	-- modes : [{'id':'off'},{'id':'auto'},{'id':'force'}]
	-- tht_cons_confort : 20
	-- tht_cons_eco : 17
	-- tht_cons_hors_gel : 15
	--------------------------------
	------ Variables à éditer ------
	--------------------------------
	
	local consigne = uservariables["tht_cons_confort"]  --Température de consigne
	local consigne_min = uservariables["tht_cons_eco"]  --Température minimum
	local consigne_hors_gel = uservariables["tht_cons_hors_gel"]
	local var_tht_temp = 'tht_temperature'
	local hysteresis = 0.5 --Valeur seuil pour éviter que le relai ne cesse de commuter dans les 2 sens
	local sonde = 'T_TH_TEMP_PALIER' --Nom de la sonde de température
	local thermostat = 'T_TH_CMD_CHAUFAGE' --Nom de l'interrupteur virtuel du thermostat
	local ouverture = 'Ouverture' --Non de l'interrupteur qui indique si une ouverture est ouverte
	local radiateur = 'T_TH_CHAUFFAGE' --Nom de la chaudière à allumer/éteindre
	--------------------------------
	-- Fin des variables à éditer --
	--------------------------------
	
	commandArray = {}
	--La sonde Oregon 'thermostat' emet toutes les 40 secondes. Ce sera approximativement la fréquence 
	-- d'exécution de ce script.
	if (devicechanged[sonde]) then
		local temperature = devicechanged[string.format('%s_Temperature', sonde)] --Temperature relevée
	    
		
		--On n'agit que si le "Thermostat" est actif
	    if (otherdevices[thermostat]=='On' ) then
	        --print('-- Gestion du thermostat --')
			-- phase confort
	    	if (temperature < (consigne - hysteresis) and otherdevices[radiateur]=='Off' and otherdevices[ouverture]=='Off') then
	            print('Allumage du chauffage')
	            commandArray[radiateur]='On'
				commandArray['Variable:' .. var_tht_temp] = tostring(consigne)
		    elseif (temperature > (consigne + hysteresis)) then
		        print('Extinction du chauffage')
	            commandArray[radiateur]='Off'
				commandArray['Variable:' .. var_tht_temp] = tostring(consigne)
		    end
		elseif (otherdevices[thermostat]=='Off') then
			-- phase eco
			if (temperature < (consigne_min - hysteresis) and otherdevices[ouverture]=='Off') then
				commandArray[radiateur]='On'
				commandArray['Variable:' .. var_tht_temp] = tostring(consigne_min)
			elseif (temperature > (consigne_min + hysteresis)) then
	            commandArray[radiateur]='Off'
				commandArray['Variable:' .. var_tht_temp] = tostring(consigne_min)
		    end
	    end
	end
return commandArray