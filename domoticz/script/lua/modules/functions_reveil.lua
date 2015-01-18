package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'Day'
require 'utils_functions'
require 'kodi_api'

--recupere les minutes
time=os.time()
istime=os.date('%H:%M',time)
istime_s=tostring(os.date('%H:%M',time))
hours=tonumber(os.date('%H',time))



	local day = Day.create()

---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------
function jourChome() 
	return day:jourChome();
end

---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------
function veilleJourChome() 
	return day:veilleJourChome()
end


Reveil = {}
Reveil.__index = Reveil

function Reveil.create(reveil_prefix,reveil_occ_prefix,scene_reveil_prefix,chevet_prefix,chevet_delai_off,heure_unset)
   local mrt = {}             -- our new object
   setmetatable(mrt,Reveil)  -- make Properties handle lookup
   mrt.reveil_prefix = reveil_prefix
   mrt.reveil_occ_prefix = reveil_occ_prefix
   mrt.scene_reveil_prefix = scene_reveil_prefix
   mrt.chevet_prefix = chevet_prefix
   mrt.chevet_delai_off = chevet_delai_off
   mrt.heure_unset = heure_unset
   return mrt
end

---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------
function Reveil:reveil_occasionnel(name_reveil)
	if (jourChome() or vacances(name_reveil)) then
		if (uservariables[self.reveil_occ_prefix ..name_reveil ] == self.heure_unset) then
			print ("PAS DE REVEIL CAR PROGRAMME A "..self.heure_unset)
		else 
		   if( istime == uservariables[self.reveil_occ_prefix ..name_reveil ]) then
				command_scene(self.scene_reveil_prefix..name_reveil,'On')
			end
			
			if (oneDeviceHasStateAfterTime(self.chevet_prefix..name_reveil,'On',self.chevet_delai_off) ) then
				 command(self.chevet_prefix..name_reveil,'Off')
			end
		end
	end
end


---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------
function Reveil:reveil_travail(name_reveil)
	if (uservariables[self.reveil_prefix ..name_reveil ] == self.heure_unset or vacances(name_reveil)) then
			print ("PAS DE REVEIL CAR PROGRAMME A "..heure_unset)
    else 
		 if(not jourChome() )then
             -- Reveil jours de travail
	         if( istime == uservariables[self.reveil_prefix ..name_reveil ]) then
		         command_scene(self.scene_reveil_prefix..name_reveil,'On')
	         end
			 
			if (oneDeviceHasStateAfterTime(self.chevet_prefix..name_reveil,'On',self.chevet_delai_off) ) then
				 command(self.chevet_prefix..name_reveil,'Off')
			end
	     end
	end
end



Coucher = {}
Coucher.__index = Coucher

function Coucher.create(var_h_coucher,var_h_coucher_dec,scene_coucher,heure_unset)
   local mrt = {}             -- our new object
   setmetatable(mrt,Coucher)  -- make Coucher handle lookup
   mrt.var_h_coucher = var_h_coucher
   mrt.var_h_coucher_dec = var_h_coucher_dec
   mrt.scene_coucher = scene_coucher
   mrt.heure_unset = heure_unset
   return mrt
end

---------------------------------------------------------------------------
--                                                                       --
--                                                                       --
--                                                                       --
---------------------------------------------------------------------------
function Coucher:coucher(name_coucher)
	
	heure_coucher = uservariables[self.var_h_coucher]
	if (heure_coucher == self.heure_unset ) then
		print ("PAS DE DODO CAR PROGRAMME A ".. self.heure_unset)
    else 
		heure_coucher_dec = uservariables[ self.var_h_coucher_dec ]
		if(veilleJourChome() or vacances(name_coucher))then
			-- Coucher veille de jours chomé
		else
			if (otherdevices['Mode Nuit'] == 'Off') then
				-- Gestion de l'heure de fin d'un films (xbmc) pour le pas couper avant la fin du films
				if( heure_coucher == heure_coucher_dec ) then
					-- Coucher veille d'un jours de travail
					if( istime == heure_coucher ) then
						 command_scene(self.scene_coucher,'On')
						 command_variable(self.var_h_coucher_dec,heure_coucher)
					end
				else
					-- afficher une alerte en cas de dépassement de l'heure
					if( istime == heure_coucher ) then
						 kodi = Kodi.createFromConf(uservariables["config_file"])
						 kodi:notification('Il devrait être l\'heure de ce coucher!!!')
						 kodi:notification('heure de dormir : '..heure_coucher_dec)
					end
					-- Coucher veille d'un jours de travail
					if( heure_coucher_dec > heure_coucher and istime == heure_coucher_dec) then
						 command_scene(scene_coucher,'On')
						 command_variable(self.var_h_coucher_dec,heure_coucher)
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