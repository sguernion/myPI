commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'
require 'functions_reveil'

---------------------------------------------
-- nommage des variables
-- reveil_prefix : 'reveil_'
-- reveil_occ_prefix : 'reveil_occ_'
-- Nommage de la scene de reveil
-- scene_reveil_prefix : 'Reveil_'
-- Nommage du swith du chevet
-- chevet_prefix : 'Chevet_'
----------------------------------------------
	local heure_unset = uservariables["heure_unset"] -- "00:00" -- Valeur qui permet d'indiquer qu'une heure n'est pas initialisée
	local reveil_prefix = 'reveil_'
	local reveil_occ_prefix = 'reveil_occ_'
	local scene_reveil_prefix = 'Reveil_'
	local chevet_prefix = 'E_CHEVET_'
	local chevet_delai_off = 1800 -- 30 min

	local reveil = Reveil.create(reveil_prefix,reveil_occ_prefix,scene_reveil_prefix,chevet_prefix,chevet_delai_off,heure_unset)
	
--print(istime..' veilleJourChome :'..tostring(veilleJourChome()) ..' jourChome: '..tostring(jourChome()))
if(auto() and not absence() and presenceAtHome()) then
	decalage_coucher_fin_films('kodi_play_duration','heure_coucher_dec',"heure_coucher","reveil_Sylvain",heure_unset)

	reveil:reveil_travail('Sylvain')
	-- reveil occasionnel
	reveil:reveil_occasionnel('Sylvain')
	
	
	coucher = Coucher.create("heure_coucher",'heure_coucher_dec','Coucher_General',heure_unset)
	coucher.coucher('Sylvain')
	
	
	if( oneDeviceHasStateAfterTime('Scene:Coucher_General','On',chevet_delai_off) and otherdevices['Multimedia_Chanbre'] == 'On') then
		 command('Multimedia_Chanbre','Off')
	end
end

return commandArray
