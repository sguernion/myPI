commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'xbmc_api'




if (devicechanged['Xbmc'] == 'Off') then
        print('Turning off XBMC')
		xbmc = Xbmc.createFromConf(uservariables["config_file"])
		xbmc:halt()
        commandArray['Multimedia']='Off After 150'
end

return commandArray