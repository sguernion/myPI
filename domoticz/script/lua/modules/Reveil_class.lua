package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'Day_class'
require 'functions_utils'
require 'functions_custom'

--recupere les minutes
time=os.time()
istime=os.date('%H:%M',time)
istime_s=tostring(os.date('%H:%M',time))
hours=tonumber(os.date('%H',time))



Reveil = {}
Reveil.__index = Reveil

function Reveil.create(reveil_prefix,reveil_occ_prefix,scene_reveil_prefix,heure_unset)
	local mrt = {}             -- our new object
	setmetatable(mrt,Reveil)  -- make Properties handle lookup
	LOG:debug ("--------- init Reveil ---------- " )
	LOG:debug ("reveil_prefix:  " .. tostring(reveil_prefix))
	LOG:debug ("reveil_occ_prefix:  " .. tostring(reveil_occ_prefix))
	LOG:debug ("scene_reveil_prefix:  " .. tostring(scene_reveil_prefix))
	LOG:debug ("--------------------------------- " )
	mrt.reveil_prefix = reveil_prefix
	mrt.reveil_occ_prefix = reveil_occ_prefix
	mrt.scene_reveil_prefix = scene_reveil_prefix
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
			LOG:debug("PAS DE REVEIL CAR PROGRAMME A "..self.heure_unset)
		else 
		   if( istime == uservariables[self.reveil_occ_prefix ..name_reveil ]) then
				command_scene(self.scene_reveil_prefix..name_reveil,'On')
				command_variable(self.reveil_prefix ..name_reveil,self.heure_unset)
				commandValue('PHASE','reveil')
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
		LOG:debug ("PAS DE REVEIL CAR PROGRAMME A "..self.heure_unset)
    else 
		 if(not jourChome() )then
             -- Reveil jours de travail
	         if( istime == uservariables[self.reveil_prefix ..name_reveil ]) then
		         command_scene(self.scene_reveil_prefix..name_reveil,'On')
				 commandValue('PHASE','reveil')
	         end
	     end
	end
end

function Reveil:initReveil(username)
	self:reveil_travail(username)
	self:reveil_occasionnel(username)
end

