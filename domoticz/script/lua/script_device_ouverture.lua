commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'

-- indique si une fenetre ou une porte est ouverte
difference = time_difference('PorteE')
if (otherdevices['PorteE'] == 'Open' and difference > 60) then
   commandArray['Ouverture']='On'
end 

if (devicechanged['PorteE'] == 'Close' ) then
   commandArray['Ouverture']='Off'
end 

return commandArray
