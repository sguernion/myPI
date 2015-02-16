package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'Day'
require 'functions_utils'
require 'functions_custom'

--recupere les minutes
time=os.time()
istime=os.date('%H:%M',time)
istime_s=tostring(os.date('%H:%M',time))
hours=tonumber(os.date('%H',time))



Reveil = {}
Reveil.__index = Reveil

function Reveil.create(reveil_prefix,reveil_occ_prefix,scene_reveil_prefix,chevet_prefix,chevet_delai_off,heure_unset)
	local mrt = {}             -- our new object
	setmetatable(mrt,Reveil)  -- make Properties handle lookup
    mrt.debug = isDebug()
	if(mrt.debug) then
		print ("--------- init Reveil ---------- " )
		print ("reveil_prefix:  " .. tostring(reveil_prefix))
		print ("reveil_occ_prefix:  " .. tostring(reveil_occ_prefix))
		print ("scene_reveil_prefix:  " .. tostring(scene_reveil_prefix))
		print ("chevet_prefix:  " .. tostring(chevet_prefix))
		print ("chevet_delai_off:  " .. tostring(chevet_delai_off))
		print ("--------------------------------- " )
	end
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
			-- print ("PAS DE REVEIL CAR PROGRAMME A "..self.heure_unset)
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
		if(self.debug) then
			print ("PAS DE REVEIL CAR PROGRAMME A "..heure_unset)
		end
    else 
		 if(not jourChome() )then
             -- Reveil jours de travail
	         if( istime == uservariables[self.reveil_prefix ..name_reveil ]) then
		         command_scene(self.scene_reveil_prefix..name_reveil,'On')
				 command_variable(self.reveil_prefix ..name_reveil,self.heure_unset)
	         end
			 
			if (oneDeviceHasStateAfterTime(self.chevet_prefix..name_reveil,'On',self.chevet_delai_off) ) then
				 command(self.chevet_prefix..name_reveil,'Off')
			end
	     end
	end
end

