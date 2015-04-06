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
    cch.debug = isDebug()
	if(cch.debug) then
		print ("--------- init Coucher ---------- " )
		print ("var_h_coucher:  " .. tostring(var_h_coucher))
		print ("var_h_coucher_dec:  " .. tostring(var_h_coucher_dec))
		print ("scene_coucher:  " .. tostring(scene_coucher))
		print ("heure_unset:  " .. tostring(heure_unset))
		print ("--------------------------------- " )
	end
   cch.var_h_coucher = var_h_coucher
   cch.var_h_coucher_dec = var_h_coucher_dec
   cch.scene_coucher = scene_coucher
   cch.heure_unset = heure_unset
   return cch
end

---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------
function Coucher:coucher_travail(name_coucher)
	if(self.debug) then
		print ("name_coucher:  " .. tostring(name_coucher))
	end
	heure_coucher = uservariables[self.var_h_coucher]
	if (heure_coucher == heure_unset ) then
		if(self.debug) then
			print ("PAS DE DODO CAR PROGRAMME A " .. tostring(heure_coucher))
		end
    else 
		heure_coucher_dec = uservariables[ self.var_h_coucher_dec ]
		if(self.debug) then
				print ("heure_coucher : " .. tostring(heure_coucher))
				print ("heure_coucher_dec : " .. tostring(heure_coucher_dec))
		end
		if(not veilleJourChome() and not vacances(name_coucher))then
			if (otherdevices['Mode Nuit'] == 'Off') then
				-- Gestion de l'heure de fin d'un films (xbmc) pour le pas couper avant la fin du films
				if( heure_coucher == heure_coucher_dec ) then
					if(self.debug) then
						print ("DODO PROGRAMME A " .. tostring(heure_coucher))
					end
					-- Coucher veille d'un jours de travail
					if( istime == heure_coucher ) then
						 command_scene(self.scene_coucher,'On')
						 command_variable(self.var_h_coucher_dec,heure_coucher)
						 command_variable('multimedia_ch_delai_off',defaut_delai_off)
						 command_variable('chevet_delai_off',defaut_delai_off)
						 command_variable('phase','coucher')
					end
				else
					if(self.debug) then
						print ("DODO décalé A " .. tostring(heure_coucher_dec))
					end
					-- afficher une alerte en cas de dépassement de l'heure
					if( istime == heure_coucher ) then
						 kodi = Kodi.createFromConf(uservariables["config_file"])
						 kodi:notification('Il devrait être l\'heure de ce coucher!!!')
						 kodi:notification('heure de dormir : '..heure_coucher_dec)
					end
					-- Coucher veille d'un jours de travail
					if( istime == heure_coucher_dec and heure_coucher_dec ~= heure_unset) then
						 command_scene(self.scene_coucher,'On')
						 command_variable(self.var_h_coucher_dec,heure_coucher)
						 command_variable('multimedia_ch_delai_off',(defaut_delai_off/2))
						 command_variable('chevet_delai_off',(defaut_delai_off/2))
						 command_variable('phase','coucher')
					end
				end
				
			end
		end
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
		-- seulement si on a paas dépaassé l'heure de couché
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
		
		--print(tostring(nhour)..':'..tostring(nminutes))
		command_variable(heure_coucher_dec_name,shour..':'..sminutes)
	end
end


function Coucher:coucher_abs(name_coucher)
	if(self.debug) then
		print ("name_coucher:  " .. tostring(name_coucher))
	end
	heure_coucher = uservariables[self.var_h_coucher]
	if (heure_coucher == heure_unset ) then
		if(self.debug) then
			print ("PAS DE DODO CAR PROGRAMME A " .. tostring(heure_coucher))
		end
    else 
		heure_coucher_dec = uservariables[ self.var_h_coucher_dec ]
		if(self.debug) then
				print ("heure_coucher : " .. tostring(heure_coucher))
				print ("heure_coucher_dec : " .. tostring(heure_coucher_dec))
		end
		if(not veilleJourChome() or not vacances(name_coucher))then
			if (otherdevices['Mode Nuit'] == 'Off') then
				-- Gestion de l'heure de fin d'un films (xbmc) pour le pas couper avant la fin du films
				if( heure_coucher == heure_coucher_dec ) then
					if(self.debug) then
						print ("DODO PROGRAMME A " .. tostring(heure_coucher))
					end
					-- Coucher veille d'un jours de travail
					if( istime == heure_coucher ) then
						 command('Mode Nuit','On')
						 command_variable('phase','coucher')
					end
				else
					if(self.debug) then
						print ("DODO décalé A " .. tostring(heure_coucher_dec))
					end
					-- Coucher veille d'un jours de travail
					if( istime == heure_coucher_dec and heure_coucher_dec ~= heure_unset) then
						 command('Mode Nuit','On')
						 command_variable('phase','coucher')
					end
				end
				
			end
		end
	end
end