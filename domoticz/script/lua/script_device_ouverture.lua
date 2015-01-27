commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'

temporisation = 60

-- indique si une fenetre ou une porte est ouverte
if (oneDeviceHasStateAfterTime('Porte','Open',temporisation)) then
   command('Ouverture','On')
end 

if (oneDeviceChangeHasState('Porte','Closed') and otherdevices['Ouverture'] == 'On') then
   command('Ouverture','Off')
end 



return commandArray
