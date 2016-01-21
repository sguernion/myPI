

Log = {}
Log.__index = Log

function Log.create()
   local mrt = {}             -- our new object
   setmetatable(mrt,Log)  -- make Log handle lookup
   mrt.level = uservariables['log_level']
   return mrt
end


function Log:debug(message) 
	if(self:isDebug() ) then
		print('DEBUG:'..message);
	end
end

function Log:info(message) 
	if(self:isInfo() or self:isDebug()) then
		print('INFO:'..message);
	end
end

function Log:warn(message) 
	if(self:isWarn()  or self:isInfo() or self:isDebug()) then
		print('WARN:'..message);
	end
end

function Log:error(message) 
	if(self:isError() or self:isInfo() or self:isWarn() or self:isDebug()) then
		error('ERROR:'..message);
	end
end

function Log:isDebug() 
	return (self.level == "debug")
end

function Log:isInfo() 
	return (self.level == "info")
end

function Log:isWarn() 
	return (self.level == "warn")
end

function Log:isError() 
	return (self.level == "error")
end
