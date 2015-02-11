--------------------------------
------Thermostat nonoZone par Hysteresis------
--------------------------------	
	
	
	--------------------------------
	------ Variables � cr�er  ------
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
	------ Variables � �diter ------
	--------------------------------
	
	local consigne = uservariables["tht_cons_confort"]  --Temp�rature de consigne
	local consigne_min = uservariables["tht_cons_eco"]  --Temp�rature minimum
	local consigne_hors_gel = uservariables["tht_cons_hors_gel"]
	local var_tht_temp = 'tht_temperature'
	local hysteresis = 0.5 --Valeur seuil pour �viter que le relai ne cesse de commuter dans les 2 sens
	local sonde = 'T_TH_TEMP_PALIER' --Nom de la sonde de temp�rature
	local thermostat = 'T_TH_CMD_CHAUFAGE' --Nom de l'interrupteur virtuel du thermostat
	local ouverture = 'Ouverture' --Non de l'interrupteur qui indique si une ouverture est ouverte
	local radiateur = 'T_TH_CHAUFFAGE' --Nom de la chaudi�re � allumer/�teindre
	--------------------------------
	-- Fin des variables � �diter --
	--------------------------------
	
	commandArray = {}
	--La sonde Oregon 'thermostat' emet toutes les 40 secondes. Ce sera approximativement la fr�quence 
	-- d'ex�cution de ce script.
	if (devicechanged[sonde]) then
		local temperature = devicechanged[string.format('%s_Temperature', sonde)] --Temperature relev�e
	    
		
		--On n'agit que si le "Thermostat" est actif
	    if (otherdevices[thermostat]=='On' ) then
	        --print('-- Gestion du thermostat --')
			-- phase confort
	    	if (temperature < (consigne - hysteresis) and otherdevices[radiateur]=='Off' and otherdevices[ouverture]=='Off') then
	            print('Allumage du chauffage')
				declenchenemtRadiateur(radiateur,'On',var_tht_temp,consigne)
		    elseif (temperature > (consigne + hysteresis)) then
		        print('Extinction du chauffage')
				declenchenemtRadiateur(radiateur,'Off',var_tht_temp,consigne)
		    end
		elseif (otherdevices[thermostat]=='Off') then
			-- phase eco
			if (temperature < (consigne_min - hysteresis) and otherdevices[ouverture]=='Off') then
				declenchenemtRadiateur(radiateur,'On',var_tht_temp,consigne_min)
			elseif (temperature > (consigne_min + hysteresis)) then
				declenchenemtRadiateur(radiateur,'Off',var_tht_temp,consigne_min)
		    end
	    end
	end
	
	
function declenchenemtRadiateur(radiateur,cmd,var_tht_temp,valeur_temp)
	 commandArray[radiateur]=cmd
	 commandArray['Variable:' .. var_tht_temp] = tostring(valeur_temp)
end
	
return commandArray