
Xbmc = {}
Xbmc.__index = Xbmc

function Xbmc.create(server,port,user,pw)
   local mrt = {}             -- our new object
   setmetatable(mrt,Xbmc)  -- make Xbmc handle lookup
   mrt.server = server
   mrt.port = port
   mrt.pw = pw
   mrt.user = user
   return mrt
end


-- 
function Xbmc:call_api(request)
	commandArray['OpenURL']='http://'..self.user.. ':'.. self.pw ..'@'.. self.server ..':'.. self.port ..'/jsonrpc?request='.. request
end

-- TODO init image, title
function Xbmc:notification(message)
	self:call_api('{"jsonrpc":"2.0","method":"GUI.ShowNotification","params":{"title":"domoticz","message":"'..message..'","image":"","displaytime":15000},"id":1}' )
end

function Xbmc:halt()
	self:notification('shutdown')
	self:call_api('{"jsonrpc":"2.0","method":"System.Shutdown","id":1}')
end


-- Use
-- xbmc = Xbmc.create('192.168.0.1','80','user','password')
-- xbmc.notification('hello world')