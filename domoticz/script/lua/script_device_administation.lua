commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Domoticz_class'



local Domoticz = Domoticz.create()
	
	
if (devicechanged['ADM_BACKUP'] == 'On' ) then
	Domoticz:backup()
end

if (devicechanged['ADM_RASPBOX_UMOUNT'] == 'On' ) then
	os.execute('sudo /home/pi/domoticz/scripts/sh/umount_raspbox.sh &')
end

if (devicechanged['ADM_DOMO_CONF'] == 'On' ) then
	LOG:info("RESET idx device configuration")
	os.execute('sudo python /home/pi/domoticz/scripts/python/domoticz_conf.py &')
end

if (devicechanged['ADM_REMOTE_LIRC'] == 'On' ) then
	LOG:info("RESET lirc configuration")
	os.execute('sudo /home/pi/domoticz/scripts/python/reset_lirc_remote_conf.py &')
end


if (devicechanged['PHASE_TESTS'] == 'On' ) then
	commandValue('PHASE','test');
end

memory = tonumber(otherdevices_svalues['M_DOMO_MEM'])
if ( memory >= 90 ) then
	-- 
	LOG:info("reset cache")
	Domoticz:resetCache()
end



if (not presenceAtHome()) then	
	alert_mesure('M_DOMO_CPU',90,'Attention!! CPU {0} : pic d\'utilisation importante','cpt_alert_cpu',5)
	alert_mesure('M_DOMO_HDD',60,'Attention!! HDD {0} : l\'espace libre diminue','cpt_alert_hdd',5)   
end

-- reboot du serveur entre 2h et 7h si la mémoire est a plus de 95%
t1 = os.date("*t")
if ( memory >= 95 and t1.hour >= 2 and t1.hour < 7 ) then
		alert_mesure('M_DOMO_MEM',95,'Raspberry rebooted #Memory usage exeeded more then 95 percent!','cpt_alert_mem',5) 
		Domoticz:reboot()
end

local bdd_size = uservariables["bdd_size"]
LOG:debug("taille bdd : " .. tostring(to_moctet (bdd_size)) .. " Mo")
if (to_moctet (bdd_size) > 15 )then
	send_sms ('Attention!! Augmentation de la taille de la base de données!!')
end



return commandArray
