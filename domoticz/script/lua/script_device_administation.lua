commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Properties_class'



local properties = Properties.create(uservariables["config_file"])
user=properties:get('free.mobile.api.user')
key=properties:get('free.mobile.api.key')

if (devicechanged['ADM_BACKUP'] == 'On' ) then
	os.execute('/home/pi/domoticz/scripts/sh/domoticz_backup.sh &')
end

if (not presenceAtHome()) then	
	
	alert_mesure('M_DOMO_CPU',70,user,key,'Attention!! CPU : pic d\'utilisation importante')
	alert_mesure('M_DOMO_HDD',60,user,key,'Attention!! HDD : l\'espace libre diminue')   

end

t1 = os.date("*t")
memory = tonumber(otherdevices_svalues['M_DOMO_MEM'])
if ( memory >= 90 and t1.hour >= 2 and t1.hour < 7 ) then
		alert_mesure('M_DOMO_MEM',70,user,key,'Raspberry rebooted#Memory usage exeeded more then 90 percent!') 
		ip=properties:get('domoticz.ip')
		port=properties:get('domoticz.port')
        os.execute('curl -s -i -H "Accept: application/json" "http://' .. ip ..':'.. port ..'/json.htm?type=command&param=system_reboot"')
end
 
   
   

   
return commandArray
