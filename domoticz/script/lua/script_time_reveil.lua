commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'
require 'marantz_api'
require 'Day'
require 'kodi_api'


day = Day.create()

function jourChome() 
	return day:jourChome();
end

function veilleJourChome() 
	return day:veilleJourChome()
end

--recupere les minutes
time=os.time()
istime=os.date('%H:%M',time)
istime_s=tostring(os.date('%H:%M',time))
hours=tonumber(os.date('%H',time))

	--------------------------------
	------ Variables à éditer ------
	--------------------------------
	local heure_reveil = uservariables["heure_reveil"] -- Heure du reveil
	local heure_unset = uservariables["heure_unset"] -- "00:00" -- Valeur qui permet d'indiquer qu'une heure n'est pas initialisée
	local scene_reveil_prefix = 'Reveil_'
	local chevet_prefix = 'Chevet_'
	local chevet_delai_off = 1800 -- 30 min
	
	local heure_coucher = uservariables["heure_coucher"] -- Heure du coucher
	local heure_coucher_dec = uservariables["heure_coucher_dec"] -- Heure du coucher avec décalage (fin de films)
	local scene_coucher = 'Coucher' -- Scene a déclencher lors du coucher
		
	
	--------------------------------
	-- Fin des variables à éditer --
	--------------------------------

decalage_coucher_fin_films('kodi_play_duration','heure_coucher_dec',heure_unset)

function reveil_travail(name_reveil,heure_reveil)
	if (heure_reveil == heure_unset or vacances(name_reveil)) then
			print ("PAS DE REVEIL CAR PROGRAMME A "..heure_unset)
    else 
		 if(not jourChome())then
             -- Reveil jours de travail
	         if( istime == heure_reveil) then
		         command_scene(scene_reveil_prefix..name_reveil,'On')
	         end
			 
			if (oneDeviceHasStateAfterTime(chevet_prefix..name_reveil,'On',chevet_delai_off) ) then
				 command(chevet_prefix..name_reveil,'Off')
			end
	     end
	 end
end


function reveil_occasionnel(name_reveil,reveil_occ)
	if (jourChome() or vacances(name_reveil)) then
		if (reveil_occ == heure_unset) then
		else 
		   if( istime == reveil_occ) then
				command_scene(scene_reveil_prefix..name_reveil,'On')
			end
			
			if (oneDeviceHasStateAfterTime(chevet_prefix..name_reveil,'On',chevet_delai_off) ) then
				 command(chevet_prefix..name_reveil,'Off')
			end
		end
	end
end
	
--print(istime..' veilleJourChome :'..tostring(veilleJourChome()) ..' jourChome: '..tostring(jourChome()))
if(auto() and not absence() and presenceAtHome()) then
	reveil_travail('Sylvain',heure_reveil)
	-- reveil occasionnel
	reveil_occasionnel('Sylvain',reveil_occ)
	
	

	
	if (heure_coucher == heure_unset ) then
		print ("PAS DE DODO CAR PROGRAMME A "..heure_unset)
    else 
		if(veilleJourChome() or vacances())then
			-- Coucher veille de jours chomé
		else
			if (otherdevices['Mode Nuit'] == 'Off') then
				-- Gestion de l'heure de fin d'un films (xbmc) pour le pas couper avant la fin du films
				if( heure_coucher == heure_coucher_dec ) then
					-- Coucher veille d'un jours de travail
					if( istime == heure_coucher ) then
						 command_scene(scene_coucher,'On')
						 command_variable('heure_coucher_dec',heure_coucher)
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
						 command_variable('heure_coucher_dec',heure_coucher)
					end
				end
				
			end
		end
	end
end

return commandArray
