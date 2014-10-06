commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'




if (devicechanged['Xbmc'] == 'Off') then
        print('Turning off XBMC')
		properties = read_file (uservariables["config_file"])
		user=trim(properties['xbmc.user'])
		pw=trim(properties['xbmc.password'])
		port=trim(properties['xbmc.port'])
		host=trim(properties['xbmc.host'])
		xbmc = Xbmc.create(host,port,user,pw)
		xbmc.halt()
        commandArray['Multimedia']='Off After 150'
end

 return commandArray