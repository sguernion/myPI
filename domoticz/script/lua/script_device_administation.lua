commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Properties_class'



local properties = Properties.create(uservariables["config_file"])

if (devicechanged['ADM_BACKUP'] == 'On' ) then
	os.execute('/home/pi/domoticz/scripts/sh/domoticz_backup.sh &')
end

if (not presenceAtHome()) then	
	alert_mesure('M_DOMO_CPU',70,properties,'Attention!! CPU : pic d\'utilisation importante')
	alert_mesure('M_DOMO_HDD',60,properties,'Attention!! HDD : l\'espace libre diminue')   
end

-- reboot du serveur entre 2h et 7h si la mémoire est a plus de 90%
t1 = os.date("*t")
memory = tonumber(otherdevices_svalues['M_DOMO_MEM'])
if ( memory >= 90 and t1.hour >= 2 and t1.hour < 7 ) then
		alert_mesure('M_DOMO_MEM',90,user,key,'Raspberry rebooted#Memory usage exeeded more then 90 percent!') 
		domoticz_reboot(properties)
end





return commandArray
