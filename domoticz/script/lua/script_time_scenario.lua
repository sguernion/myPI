commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'
require 'marantz_api'
require 'Day'
require 'xbmc_api'


day = Day.create()

function jourChome() 
	return day:jourChome();
end

function veilleJourChome() 
	return day:veilleJourChome()
end

--recupere les minutes
time=os.time()
istime=tostring(os.date('%H:%M',time))
hours=tonumber(os.date('%H',time))

	--------------------------------
	------ Variables à éditer ------
	--------------------------------
	local heure_reveil = uservariables["heure_reveil"] -- Heure du reveil
	local heure_reveil_off = uservariables["heure_reveil_off"] -- Heure de fin du reveil
	local heure_coucher = uservariables["heure_coucher"] -- Heure du coucher
	local heure_coucher_dec = uservariables["heure_coucher_dec"] -- Heure du coucher avec décalage (fin de films)
	local heure_unset = "00:00" -- Valeur qui permet d'indiquer qu'une heure n'est pas initialisée
	
	local scene_reveil = 'Reveil' -- Scene a déclencher lors du reveil
	local scene_coucher = 'Coucher' -- Scene a déclencher lors du coucher
	--------------------------------
	-- Fin des variables à éditer --
	--------------------------------
	
--print(istime..' veilleJourChome :'..tostring(veilleJourChome()) ..' jourChome: '..tostring(jourChome()))
if(auto() and not absence() and presenceAtHome()) then
        if (heure_reveil == heure_unset) then
			print ("PAS DE REVEIL CAR PROGRAMME A "..heure_unset)
        else 
	        if(not jourChome())then
					print('Reveil '..heure_reveil)
                        -- Reveil jours de travail
	                if( istime == heure_reveil) then
		                 command_scene(scene_reveil,'On')
	                end
	                if( istime == heure_reveil_off) then
		                 command('Chevet','Off')
	                end	
	        else
		        -- Reveil jours chomé
		
	        end
	end

	
	if (heure_coucher == heure_unset ) then
		print ("PAS DE DODO CAR PROGRAMME A "..heure_unset)
    else 
		if(veilleJourChome())then
			-- Coucher veille de jours chomé
		else
			if (otherdevices['Mode Nuit'] == 'Off') then
				-- Gestion de l'heure de fin d'un films (xbmc) pour le pas couper avant la fin du films
				if( uheure_coucher == heure_coucher_dec ) then
					-- Coucher veille d'un jours de travail
					if( istime == heure_coucher ) then
						 command_scene(scene_coucher,'On')
					end
				else
					-- afficher une alerte en cas de dépassement de l'heure
					if( istime == heure_coucher ) then
						 xbmc = Xbmc.createFromConf(uservariables["config_file"])
						 xbmc:notification('Il devrait être l\'heure de ce coucher!!!')
						 xbmc:notification('heure de dormir : '..heure_coucher_dec)
					end
					-- Coucher veille d'un jours de travail
					if( istime == heure_coucher_dec) then
						 command_scene(scene_coucher,'On')
						 command_variable('heure_coucher_dec',heure_coucher)
					end
				end
				
			end
		end
	end
end

-- mode absence, on eteint tout
if(absence()) then
	devicesOff()
end


return commandArray
