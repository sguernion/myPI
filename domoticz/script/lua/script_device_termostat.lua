	--------------------------------
	------ Variables à éditer ------
	--------------------------------
	local consigne = uservariables["Consigne"]  --Température de consigne
	local consigne_min = uservariables["Consigne_eco"]  --Température minimum
	local hysteresis = 0.5 --Valeur seuil pour éviter que le relai ne cesse de commuter dans les 2 sens
	local sonde = 'Temp Chambre2' --Nom de la sonde de température
	local thermostat = 'Calendrier Chauffage' --Nom de l'interrupteur virtuel du thermostat
	local radiateur = 'Chauffage' --Nom du radiateur à allumer/éteindre
	--------------------------------
	-- Fin des variables à éditer --
	--------------------------------
	
	commandArray = {}
	--La sonde Oregon 'thermostat' emet toutes les 40 secondes. Ce sera approximativement la fréquence 
	-- d'exécution de ce script.
	if (devicechanged[sonde]) then
		local temperature = devicechanged[string.format('%s_Temperature', sonde)] --Temperature relevée
	    --On n'agit que si le "Thermostat" est actif
	    if (otherdevices[thermostat]=='On') then
	        --print('-- Gestion du thermostat --')
	
	    	if (temperature < (consigne - hysteresis) and otherdevices[radiateur]=='Off' ) then
	            print('Allumage du chauffage')
	            commandArray[radiateur]='On'
	
		    elseif (temperature > (consigne + hysteresis)) then
		        print('Extinction du chauffage')
	            commandArray[radiateur]='Off'
	
		    end
		elseif (otherdevices[thermostat]=='Off') then
			if (temperature < (consigne_min - hysteresis)) then
				commandArray[radiateur]='On'
			elseif (temperature > (consigne_min + hysteresis)) then
	            commandArray[radiateur]='Off'
		    end
	    end
	end
return commandArray