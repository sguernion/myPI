commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Reveil_class'
require 'Coucher_class'
require 'Properties_class'
require 'Domoticz_class'


	---------------------------------------------
	-- nommage des variables
	-- reveil_prefix : 'reveil_'
	-- reveil_occ_prefix : 'reveil_occ_'
	-- Nommage de la scene de reveil
	-- scene_reveil_prefix : 'Reveil_'
	-- Nommage du swith du chevet
	----------------------------------------------
	--           Début valeur a éditer          --
	----------------------------------------------
	local reveil_prefix = 'reveil_'
	local reveil_occ_prefix = 'reveil_occ_'
	local scene_reveil_prefix = 'Reveil_'
	local chevet_prefix = 'E_CHEVET_'
	
	local var_heure_coucher = 'heure_coucher'
	local var_multimedia_ch_delai_off = 'multimedia_ch_delai_off'
	local var_heure_coucher_dec = 'heure_coucher_dec'
	local var_kodi_play_duration = 'kodi_play_duration'
	local var_heure_unset = 'heure_unset'
	local var_defaut_delai_off = "defaut_delai_off"
		
	local scene_coucher = 'Coucher_General'

	----------------------------------------------
	--           Fin valeur a éditer            --
	----------------------------------------------
	local properties = Properties.create(uservariables["config_file"])

	-------------------------------------
	------ création des Variables  ------
	-------------------------------------
    --local Domoticz = Domoticz.create()
	--Domoticz:addVariable(0,var_defaut_delai_off,'30')
	--Domoticz:addVariable(0,var_multimedia_ch_delai_off,'30')
	--Domoticz:addVariable(4,var_kodi_play_duration,'00:00')
	--Domoticz:addVariable(4,var_heure_unset,'00:00')
	--Domoticz:addVariable(4,var_heure_coucher,'00:00')
	--Domoticz:addVariable(4,var_heure_coucher_dec,'00:00')
			
	--for i,username in pairs(properties:getArray('reveil.usernames')) do 
	--	if (username  ~= nil and trim(tostring(username))  ~= '') then
	--		Domoticz:addVariable(4,reveil_prefix..username,'00:00')
	--		Domoticz:addVariable(4,reveil_occ_prefix..username,'00:00')
	--	end
	--end

	-- Valeur qui permet d'indiquer qu'une heure n'est pas initialisée
	local heure_unset = uservariables[var_heure_unset] -- "00:00" 
	
	

	
	local reveil = Reveil.create(reveil_prefix,reveil_occ_prefix,scene_reveil_prefix,heure_unset)
	local ch = Coucher.create(var_heure_coucher,var_heure_coucher_dec,scene_coucher,heure_unset) --

function watchingVideo() 
	return otherdevices['P_KODI'] == 'On' and  otherdevices['OSMC'] == 'Video'
end


function multimediaDelayOff()
	d_MultiMEdiaCh ='Multimedia_Chambre'
	local multimedia_ch_delai_off = to_seconde(uservariables[var_multimedia_ch_delai_off])  -- 30 min
	local defaut_delai_off= uservariables[var_defaut_delai_off]  -- 30 min

	if( oneDeviceHasStateAfterTime(MultiMEdiaCh,'On',multimedia_ch_delai_off) and otherdevices['Mode Nuit'] == 'On') 		then
		 command(MultiMEdiaCh,'Off')
		 command_variable(var_multimedia_ch_delai_off,defaut_delai_off)
		 commandValue('PHASE','nuit')
	end
end
	

if(auto() and not absence() and presenceAtHome()) then
	for i,username in pairs(properties:getArray('reveil.usernames')) do 
		if (username  ~= nil and trim(tostring(username))  ~= '') then
			LOG:debug('-'..username..'-')
			if ( watchingVideo() ) then
				decalage_coucher_fin_films(var_kodi_play_duration,var_heure_coucher_dec,var_heure_coucher,reveil_prefix .. username,heure_unset)
			end

			reveil:initReveil(username)
			ch:coucher(username)
		end
	end

	multimediaDelayOff()
end

	
if(auto() and ( absence() or not presenceAtHome())) then
	ch:coucher_absence()
end


return commandArray
