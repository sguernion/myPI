commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'

--for i, v in pairs(otherdevices) do print(i, v) end

-- indique si une fenetre ou une porte est ouverte
--if (oneDeviceHasStateAfterTime('Porte','Open',60)) then
--   commandArray['Ouverture']='On'
--end 

--if (oneDeviceHasState('Porte','Close') and otherdevices['Ouverture'] == 'On') then
--   commandArray['Ouverture']='Off'
--end 


--- indique si une fenetre ou une porte est ouverte
difference = time_difference('PorteE')
if (otherdevices['PorteE'] == 'Open' and difference > 60) then
   commandArray['Ouverture']='On'
end 

if (otherdevices['PorteE'] == 'Close' and otherdevices['Ouverture'] == 'On' ) then
   commandArray['Ouverture']='Off'
end 

return commandArray
