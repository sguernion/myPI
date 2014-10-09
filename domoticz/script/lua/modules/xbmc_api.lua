
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'utils_functions'
require 'properties'

Xbmc = {}
Xbmc.__index = Xbmc

function Xbmc.create(server,port,user,pw)
   local mrt = {}             -- our new object
   setmetatable(mrt,Xbmc)  -- make Xbmc handle lookup
   mrt.server = server
   mrt.port = port
   mrt.pw = pw
   mrt.user = user
   mrt.id = 1
   return mrt
end

function Xbmc.createFromConf(config)
   local mrt = {}             -- our new object
   setmetatable(mrt,Xbmc)  -- make Xbmc handle lookup
   properties = Properties.create(config)
   mrt.server = properties:get('xbmc.host')
   mrt.port = properties:get('xbmc.port')
   mrt.pw = properties:get('xbmc.pw')
   mrt.user = properties:get('xbmc.user')
   mrt.title = properties:get('xbmc.notification.title')
   mrt.image = properties:get('xbmc.notification.image')
   mrt.id = 1
   return mrt
end

-- 
function Xbmc:call_api(request)
	commandArray['OpenURL']='http://'..self.user.. ':'.. self.pw ..'@'.. self.server ..':'.. self.port ..'/jsonrpc?request='.. request
end

function Xbmc:call_method(method,params)
	jsonParam=''
	if(params  ~= nil and params  ~= '')then
		jsonParam='"params": '..params
	end
	self:call_api('{"jsonrpc": "2.0", "method": "'..method..'",'..jsonParam..' "id": '.. self.id ..'}')
end

function Xbmc:notification(message)
	self:call_method('GUI.ShowNotification','{"title":"'.. self.title ..'","message":"'..message..'","image":"'.. self.image ..'","displaytime":15000}')
end

function Xbmc:play_pause()
	self:call_method('Player.PlayPause','{"playerid": 1}')
end

function Xbmc:stop()
	self:call_method('Player.Stop','{"playerid": 1}')
end

function Xbmc:home()
	self:call_method('Input.Home','')
end

function Xbmc:up()
	self:call_method('Input.Up','')
end

function Xbmc:down()
	self:call_method('Input.Down','')
end

function Xbmc:left()
	self:call_method('Input.Left','')
end

function Xbmc:right()
	self:call_method('Input.Right','')
end

function Xbmc:select()
	self:call_method('Input.Select','')
end

function Xbmc:back()
	self:call_method('Input.Back','')
end

function Xbmc:reboot()
	self:call_method('System.Reboot','')
end

function Xbmc:halt()
	self:notification('shutdown')
	self:call_method('System.Shutdown','')
end


-- Use
-- xbmc = Xbmc.create('192.168.0.1','80','user','password')
-- xbmc.notification('hello world')