
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'functions_utils'
require 'functions_custom'
require 'Properties_class'

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
   local name = 'kodi'
   properties = Properties.create(config)
   mrt.server = properties:get(name..'.host')
   mrt.port = properties:get(name..'.port')
   mrt.pw = properties:get(name..'.pw')
   mrt.user = properties:get(name..'.user')
   mrt.title = properties:get(name..'.notification.title')
   mrt.image = properties:get(name..'.notification.image')
   mrt.id = 1
   return mrt
end

function Kodi.createFrom(name,config)
   local mrt = {}             -- our new object
   setmetatable(mrt,Kodi)  -- make kodi handle lookup
   properties = Properties.create(config)
   mrt.server = properties:get(name..'.host')
   mrt.port = properties:get(name..'.port')
   mrt.pw = properties:get(name..'.pw')
   mrt.user = properties:get(name..'.user')
   mrt.title = properties:get(name..'.notification.title')
   mrt.image = properties:get(name..'.notification.image')
   mrt.id = 1
   return mrt
end

-- 
function Kodi:call_api(request)
	--'..self.user.. ':'.. self.pw ..'@'
	url = 'http://'.. self.server ..':'.. self.port ..'/jsonrpc?request='.. request
	LOG:info(url)
	commandArray['OpenURL']= url
	--os.execute('curl '..url)
end

function Kodi:call_method(method,params)
	jsonParam=''
	if(params  ~= nil and params  ~= '')then
		jsonParam='"params":'..params ..','
	end
	self:call_api('{"jsonrpc":"2.0","method":"'..method..'",'..jsonParam..'"id":'.. self.id ..'}')
end

function Kodi:notification(message)
	self:call_method('GUI.ShowNotification','{"title":"'.. self.title ..'","message":"'..message..'","image":"'.. self.image ..'","displaytime":15000}')
end

function Kodi:play_pause()
	self:call_method('Player.PlayPause','{"playerid":1}')
end

function Kodi:party()
	self:call_method('Player.Open','{"item":{"partymode":"music"}}')
end

function Kodi:stop()
	self:call_method('Player.Stop','{"playerid":1}')
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

function Kodi:videoScan()
	self:call_method('VideoLibrary.Scan','')
end

function Kodi:audioScan()
	self:call_method('AudioLibrary.Scan','')
end

function Kodi:videoClean()
	self:call_method('VideoLibrary.Clean','')
end

function Kodi:audioClean()
	self:call_method('AudioLibrary.Clean','')
end

function Kodi:subtitle()
	self:call_method('layer.SetSubtitle','')
end

	
function Kodi:halt()
	--self:notification('shutdown')
	self:call_method('System.Shutdown','')
end


-- Use
-- Kodi = Kodi.create('192.168.0.1','80','user','password')
-- Kodi.notification('hello world')
