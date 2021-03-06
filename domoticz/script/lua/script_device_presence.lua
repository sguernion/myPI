commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'

local delai_min = to_seconde(1)
local delai_max = to_seconde(4)

if(auto()) then
	-- extinction de tout les appareils
	if ( devicechanged['Mode Nuit'] == 'On') then
		devicesOff()
	end

	if (oneDeviceChangeHasState('P_Smartphone','On') and otherdevices['Mode Nuit'] == 'Off') then
		   LOG:info('presence Wifi Go Home')
		   command_scene('Presence','On')
		   commandValue('PHASE','retour');
	elseif (devicechanged['Mode Nuit'] == 'Off' and oneDeviceHasState('P_Smartphone','On')) then
		   LOG:info('presence : Levée')
		   command_scene('Presence','On')
	elseif (not presenceAtHome() and oneDeviceTime_difference_between('P_Smartphone',delai_min,delai_max)) then
		   allOff()
	end

	-- lumiere d'appoint lors d'un deplacement la nuit dans le séjour
	if ( otherdevices['Mode Nuit'] == 'On') then
		if ( devicechanged['P_GENERALE_MOTION'] == 'On' and otherdevices['E_LAMPE_SEJOUR'] == 'Off' and getLuxValue('P_LUX_SALLE') < 200) then
			command('E_LAMPE_SEJOUR','On')
		end

		if ( devicechanged['P_GENERALE_MOTION'] == 'Off' and otherdevices['E_LAMPE_SEJOUR'] == 'On') then
			command('E_LAMPE_SEJOUR','Off')
		end
	end

end

if(absence() and otherdevices['MultipriseS'] == 'On' ) then
	allOff()
end

-- va permetre de lisser la dectection de mouvement
if (oneDeviceChangeHasState('P_MOTION','On')) then
	command('P_GENERALE_MOTION','On')
end

-- si aucun mouvement depuis 5 min, on repasse a Off
if (oneDeviceHasStateAfterTime('P_GENERALE_MOTION','On',to_seconde (5))) then
	command('P_GENERALE_MOTION','Off')
end



return commandArray
