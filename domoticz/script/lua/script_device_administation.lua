commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Properties_class'



local properties = Properties.create(uservariables["config_file"])

if (devicechanged['ADM_BACKUP'] == 'On' ) then
	os.execute('/home/pi/domoticz/scripts/sh/domoticz_backup.sh &')
end

if (devicechanged['PHASE_TESTS'] == 'On' ) then
	commandValue('PHASE','test');
end


if (not presenceAtHome()) then	
	alert_mesure('M_DOMO_CPU',90,properties,'Attention!! CPU : pic d\'utilisation importante','cpt_alert_cpu',5)
	alert_mesure('M_DOMO_HDD',60,properties,'Attention!! HDD : l\'espace libre diminue','cpt_alert_hdd',5)   
end

-- reboot du serveur entre 2h et 7h si la mémoire est a plus de 90%
t1 = os.date("*t")
memory = tonumber(otherdevices_svalues['M_DOMO_MEM'])
if ( memory >= 90 and t1.hour >= 2 and t1.hour < 7 ) then
		alert_mesure('M_DOMO_MEM',90,properties,'Raspberry rebooted #Memory usage exeeded more then 90 percent!','cpt_alert_mem',5) 
		domoticz_reboot(properties)
end

local bdd_size = uservariables["bdd_size"]
--print "taille bdd : " .. tostring(to_moctet (bdd_size)) .. " Mo"
if (to_moctet (bdd_size) > 15 )then
	send_sms (properties,'Attention!! Augmentation de la taille de la base de données!!')
end

return commandArray
