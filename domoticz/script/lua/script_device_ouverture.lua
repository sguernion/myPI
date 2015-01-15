commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'

--for i, v in pairs(otherdevices) do print(i, v) end

-- indique si une fenetre ou une porte est ouverte
if (oneDeviceHasStateAfterTime('Porte','Open',60)) then
   commandArray['Ouverture']='On'
end 

if (oneDeviceChangeHasState('Porte','Closed') and otherdevices['Ouverture'] == 'On') then
   commandArray['Ouverture']='Off'
end 



return commandArray
