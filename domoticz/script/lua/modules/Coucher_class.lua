package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'Day_class'
require 'functions_utils'
require 'functions_custom'
require 'Kodi_class'

--recupere les minutes
time=os.time()
istime=os.date('%H:%M',time)
istime_s=tostring(os.date('%H:%M',time))
hours=tonumber(os.date('%H',time))
defaut_delai_off=30


Coucher = {}
Coucher.__index = Coucher

function Coucher.create(var_h_coucher,var_h_coucher_dec,scene_coucher,heure_unset) --
   local cch = {}             -- our new object
   setmetatable(cch,Coucher)  -- make Coucher handle lookup
	LOG:debug ("--------- init Coucher ---------- " )
	LOG:debug ("var_h_coucher:  " .. tostring(var_h_coucher))
	LOG:debug ("var_h_coucher_dec:  " .. tostring(var_h_coucher_dec))
	LOG:debug ("scene_coucher:  " .. tostring(scene_coucher))
	LOG:debug ("heure_unset:  " .. tostring(heure_unset))
	LOG:debug ("--------------------------------- " )
   cch.var_h_coucher = var_h_coucher
   cch.var_h_coucher_dec = var_h_coucher_dec
   cch.scene_coucher = scene_coucher
   cch.heure_unset = heure_unset
   cch.deviceModeNuit='Mode Nuit'
   cch.devicePhase = 'PHASE'
   cch.var_multimedia_ch_delai_off = 'multimedia_ch_delai_off'
   return cch
end

---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------

function Coucher:activeCoucher()
	isEndDay=hours >= 12
	isStartDay=hours <12
	return ((not veilleJourChome()) and  isEndDay ) or ( not jourChome() and isStartDay)
end

function Coucher:coucher(name_coucher)
	LOG:debug ("name_coucher:  " .. tostring(name_coucher)) 
	heure_coucher = uservariables[self.var_h_coucher]
	if (heure_coucher == self.heure_unset or vacances(name_coucher)) then
		LOG:debug ("PAS DE DODO CAR PROGRAMME A " .. tostring(heure_coucher))
    	else 
		if(self:activeCoucher() and not vacances(name_coucher) and otherdevices[self.deviceModeNuit] == 'Off')then
			heure_coucher_dec = uservariables[ self.var_h_coucher_dec ]
			LOG:debug ("heure_coucher : " .. tostring(heure_coucher))
			LOG:debug ("heure_coucher_dec : " .. tostring(heure_coucher_dec))
			-- Gestion de l'heure de fin d'un films (xbmc) pour le pas couper avant la fin du films
			if( heure_coucher == heure_coucher_dec ) then
				LOG:debug("DODO PROGRAMME A " .. tostring(heure_coucher))
				-- Coucher veille d'un jours de travail
				if( istime == heure_coucher ) then
					 self:isTime(defaut_delai_off) 
				end
			else
				LOG:debug("DODO décalé A " .. tostring(heure_coucher_dec))
				
				-- afficher une alerte en cas de dépassement de l'heure
				self:notificationKodi(heure_coucher,heure_coucher_dec) 
				-- Coucher veille d'un jours de travail
				if( istime == heure_coucher_dec and heure_coucher_dec ~= heure_unset) then
					 self:isTime((defaut_delai_off/2)) 	
				end
			end
		end
	end
end

function Coucher:isTime(delai_off) 
	command_scene(self.scene_coucher,'On')
	command_variable(self.var_h_coucher_dec,heure_coucher)
	command_variable(self.var_multimedia_ch_delai_off,delai_off)
	commandValue(self.devicePhase,'coucher')
end

function Coucher:notificationKodi(heure_coucher,heure_coucher_dec) 
	if( istime == heure_coucher ) then
		kodi = Kodi.createFromConf(uservariables["config_file"])
		kodi:notification('Il devrait être l\'heure de ce coucher!!!')
		kodi:notification('heure de dormir : '..heure_coucher_dec)
	end
end
---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------
function decalage_coucher_fin_films (kodi_play_dur_name,heure_coucher_dec_name,var_h_coucher,var_h_reveil,heure_unset)
	if (uservariables[kodi_play_dur_name] == heure_unset ) then
		-- aucun decalage, reset heure coucher
		-- seulement si on a pas dépassé l'heure de couché
		t_minutes=tonumber(os.date('%M',os.time()))
 		hours=tonumber(os.date('%H',os.time()))
 		nhour =  tonumber(string.sub(uservariables[var_h_coucher], 0, 2))
 		nminutes =  tonumber(string.sub(uservariables[var_h_coucher], 4, 5))
 		nhour_R =  tonumber(string.sub(uservariables[var_h_reveil], 0, 2))
 
 		
 		if(hours >= nhour) then 
 			if(t_minutes >= nminutes) then 
 				sminutes = tostring(nminutes+2)
 				shour = tostring(nhour)
 				command_variable(heure_coucher_dec_name,shour..':'..sminutes)
 			end
 		end
 		
 		if(hours < nhour_R) then 
 			sminutes = tostring(nminutes+2)
 			shour = tostring(nhour)
 			command_variable(heure_coucher_dec_name,shour..':'..sminutes)
 		end
		command_variable(heure_coucher_dec_name,uservariables[var_h_coucher])
	else 
		t_minutes=tonumber(os.date('%M',time)) + 3
		hours=tonumber(os.date('%H',time))
		nhour = hours + tonumber(string.sub(uservariables[kodi_play_dur_name], 0, 2))
		nminutes = t_minutes + tonumber(string.sub(uservariables[kodi_play_dur_name], 4, 5))
		if( nminutes > 60 ) then 
			nhour = nhour+1
			nminutes = nminutes -60
		end
		if( nhour > 23 ) then 
			nhour = nhour-23
		end
		
		sminutes = tostring(nminutes)
		if( nminutes < 10 ) then 
			sminutes = '0'..sminutes
		end
		
		shour = tostring(nhour)
		if( nhour < 10 ) then 
			shour = '0'..shour
		end
		
		LOG:debug(tostring(nhour)..':'..tostring(nminutes))
		command_variable(heure_coucher_dec_name,shour..':'..sminutes)
	end
end


function Coucher:coucher_absence()
	
	heure_coucher = uservariables[self.var_h_coucher]
	if (heure_coucher == self.heure_unset ) then
		LOG:debug("PAS DE DODO CAR PROGRAMME A " .. tostring(heure_coucher))
    	else 
		heure_coucher_dec = uservariables[ self.var_h_coucher_dec ]
		LOG:debug ("heure_coucher : " .. tostring(heure_coucher))
		LOG:debug ("heure_coucher_dec : " .. tostring(heure_coucher_dec))
		if(self:activeCoucher() and otherdevices[self.deviceModeNuit] == 'Off' )then
			-- Gestion de l'heure de fin d'un films (xbmc) pour le pas couper avant la fin du films
			if( heure_coucher == heure_coucher_dec ) then
				LOG:debug ("DODO PROGRAMME A " .. tostring(heure_coucher))
				-- Coucher veille d'un jours de travail
				if( istime == heure_coucher ) then
					 command(self.deviceModeNuit,'On')
				end
			else
				LOG:debug ("DODO décalé A " .. tostring(heure_coucher_dec))
				-- Coucher veille d'un jours de travail
				if( istime == heure_coucher_dec and heure_coucher_dec ~= self.heure_unset) then
					 command(self.deviceModeNuit,'On')
				end
			end
		end
	end
end
