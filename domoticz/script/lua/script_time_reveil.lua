commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Reveil_class'
require 'Coucher_class'
require 'Day_class'



local day = Day.create()
local today=os.date("%Y-%m-%d")
if( today ~= string.sub(uservariables_lastupdate['jour'],0,10) ) then
	day:initSaison()
	day:initJoursChome()
	day:initJour()
end


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
	local chevet_delai_off = uservariables["chevet_delai_off"]  -- 30 min
	local multimedia_ch_delai_off = uservariables["multimedia_ch_delai_off"]  -- 30 min
	local defaut_delai_off=30
	
	local heure_coucher = 'heure_coucher'
	local heure_coucher_dec = 'heure_coucher_dec'
	local scene_coucher = 'Coucher_General'
	
	local username = 'Sylvain'

	local reveil = Reveil.create(reveil_prefix,reveil_occ_prefix,scene_reveil_prefix,chevet_prefix,chevet_delai_off,heure_unset)
	local ch = Coucher.create(heure_coucher,heure_coucher_dec,scene_coucher,heure_unset) --
	
--print(istime..' veilleJourChome :'..tostring(veilleJourChome()) ..' jourChome: '..tostring(jourChome()))
if(auto() and not absence() and presenceAtHome()) then
	if ( otherdevices['P_KODI'] == 'On' ) then
		decalage_coucher_fin_films('kodi_play_duration',heure_coucher_dec,heure_coucher,reveil_prefix .. username,heure_unset)
	end
	reveil:reveil_travail(username)
	-- reveil occasionnel
	reveil:reveil_occasionnel(username)
	
	
	
	ch:coucher_travail(username)
	
	if( oneDeviceHasStateAfterTime('Multimedia_Chambre','On',to_seconde(multimedia_ch_delai_off)) and otherdevices['Mode Nuit'] == 'On') then
		 command('Multimedia_Chambre','Off')
		 command_variable('multimedia_ch_delai_off',defaut_delai_off)
	end
end

time=os.time()
	istime=os.date('%H:%M',time)
	if( istime == '20:00') then
		command_variable('phase','soiree')
	end

if(auto() and ( absence() or not presenceAtHome())) then
	ch:coucher_abs(name_coucher)
end
return commandArray
