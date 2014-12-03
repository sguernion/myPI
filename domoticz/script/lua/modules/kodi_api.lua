
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'
require 'properties'

Kodi = {}
Kodi.__index = Kodi

function Kodi.create(server,port,user,pw)
   local mrt = {}             -- our new object
   setmetatable(mrt,Kodi)  -- make Kodi handle lookup
   mrt.server = server
   mrt.port = port
   mrt.pw = pw
   mrt.user = user
   mrt.id = 1
   return mrt
end

function Kodi.createFromConf(config)
   local mrt = {}             -- our new object
   setmetatable(mrt,Kodi)  -- make kodi handle lookup
   properties = Properties.create(config)
   mrt.server = properties:get('kodi.host')
   mrt.port = properties:get('kodi.port')
   mrt.pw = properties:get('kodi.pw')
   mrt.user = properties:get('kodi.user')
   mrt.title = properties:get('kodi.notification.title')
   mrt.image = properties:get('kodi.notification.image')
   mrt.id = 1
   return mrt
end

-- 
function Kodi:call_api(request)
	commandArray['OpenURL']='http://'..self.user.. ':'.. self.pw ..'@'.. self.server ..':'.. self.port ..'/jsonrpc?request='.. request
end

function Kodi:call_method(method,params)
	jsonParam=''
	if(params  ~= nil and params  ~= '')then
		jsonParam='"params": '..params
	end
	self:call_api('{"jsonrpc": "2.0", "method": "'..method..'",'..jsonParam..' "id": '.. self.id ..'}')
end

function Kodi:notification(message)
	self:call_method('GUI.ShowNotification','{"title":"'.. self.title ..'","message":"'..message..'","image":"'.. self.image ..'","displaytime":15000}')
end

function Kodi:play_pause()
	self:call_method('Player.PlayPause','{"playerid": 1}')
end

function Kodi:stop()
	self:call_method('Player.Stop','{"playerid": 1}')
end

function Kodi:home()
	self:call_method('Input.Home','')
end

function Kodi:up()
	self:call_method('Input.Up','')
end

function Kodi:down()
	self:call_method('Input.Down','')
end

function Kodi:left()
	self:call_method('Input.Left','')
end

function Kodi:right()
	self:call_method('Input.Right','')
end

function Kodi:select()
	self:call_method('Input.Select','')
end

function Kodi:back()
	self:call_method('Input.Back','')
end

function Kodi:reboot()
	self:call_method('System.Reboot','')
end

function Kodi:halt()
	self:notification('shutdown')
	self:call_method('System.Shutdown','')
end


-- Use
-- Kodi = Kodi.create('192.168.0.1','80','user','password')
-- Kodi.notification('hello world')