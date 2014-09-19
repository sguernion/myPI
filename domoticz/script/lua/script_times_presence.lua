commandArray = {}



-- 
if (otherdevices['Smartphone'] == 'On' && otherdevices['Mode Nuit'] == 'Off') then
       commandArray['Multiprise Séjour']='On'
elseif ((otherdevices['Smartphone'] == 'Off' && otherdevices['PC'] == 'Off' )|| otherdevices['Mode Nuit'] == 'On') 
	  commandArray['Multiprise Séjour']='Off'
end

-- Allumage automatique de la lampe quand la tv est allumée et qu'il fait nuit
if (otherdevices['Nuit'] == 'On' && otherdevices['Tv'] == 'On') then
	commandArray['Lampe Séjour']='On'
elseif (otherdevices['Nuit'] = 'Off')
	commandArray['Lampe Séjour']='Off'
end

-- extinction de tout les appareils
if ( otherdevices['Mode Nuit'] == 'On') then
	print('Turning off all device')
	commandArray['Générale']='Off'
end
return commandArray