commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'properties'



local properties = Properties.create(uservariables["config_file"])
user=properties:get('free.mobile.api.user')
key=properties:get('free.mobile.api.key')

if (devicechanged['ADM_BACKUP'] == 'On' ) then
	os.execute('/home/pi/domoticz/scripts/sh/domoticz_backup.sh &')
end

if (not presenceAtHome()) then	
	
	alert_mesure('CPU_Usage',70,user,key,'Attention!! CPU : pic d\'utilisation importante')
	alert_mesure('HDD',60,user,key,'Attention!! HDD : l\'espace libre diminue')   

end
   
   
   

   
return commandArray
