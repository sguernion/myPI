commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'properties'

-- Script qui permet de savoir si certains appareils sont allumés et sur le reseau local
--
--
-- auteur : sguernion
-- date : 24/09/2014
--
--
--	Configuration du fichier config.properties
--	servers.ping.device=Device1,Device2
--	server.Device1.ip=192.168.0.1
--	server.Device2.ip=192.168.0.2
--


local properties = Properties.create(uservariables["config_file"])

for i,server in pairs(properties:getArray('servers.ping.device')) do 
	if (server  ~= nil and server  ~= '') then
		--print('device : '.. server)
		ping_alive(server,properties:get('server.' .. server .. '.ip'))
	end
end

return commandArray