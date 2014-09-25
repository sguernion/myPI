commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'


properties = read_file ("/home/pi/domoticz/scripts/lua/config.properties")
user= properties['xbmc.user']
pw= properties['xbmc.password']
port= properties['xbmc.port']
host= properties['xbmc.host']

if (devicechanged['Xbmc'] == 'Off') then
        print('Turning off XBMC')
		send_xbmc_cmd (user,pw,host,port,'{"jsonrpc":"2.0","method":"System.Shutdown","id":1}')
        commandArray['Multimedia']='Off After 150'
end

 return commandArray