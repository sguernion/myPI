commandArray = {}
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'
require 'properties'


local properties = Properties.create(uservariables["config_file"])
user=properties:get('free.mobile.api.user')
key=properties:get('free.mobile.api.key')

if (devicechanged['ADM_BACKUP'] == 'On' ) then
	os.execute('/home/pi/domoticz/scripts/sh/domoticz_backup.sh &')
end

if (not presenceAtHome()) then	
if devicechanged['CPU_Usage'] then
   cpu = tonumber(otherdevices_svalues['CPU_Usage'])
   if cpu > 70 then
		print('CPU : '.. tostring(cpu))
		send_sms (user,key,'Attention!! CPU : pi d\'utilisation important')
   end
end
	
if devicechanged['HDD'] then
   hdd = tonumber(otherdevices_svalues['HDD'])
   if hdd > 60 then
		print('HDD : '.. tostring(hdd))
		send_sms (user,key,'Attention!! HDD : l\'espace libre diminue')
   end
end
   end
return commandArray
