

Properties = {}
Properties.__index = Properties

function read_file (fileName)
  property = {}
  for line in io.lines(fileName) do
    for key, value in string.gmatch(line, '(.-)=(.-)$') do 
      property[key] = value 
    end
  end
  return property
end

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end


function Properties.create(config)
   local mrt = {}             -- our new object
   setmetatable(mrt,Properties)  -- make Properties handle lookup
   mrt.properties = read_file (config)
   return mrt
end

function Properties:get(key)
  return trim(self.properties[key])
end

function Properties:getArray(key)
  return self:split(self.properties[key], ',')
end



 
function Properties:split (s, pattern, maxsplit)
  local pattern = pattern or ' '
  local maxsplit = maxsplit or -1
  local s = s
  local t = {}
  local patsz = #pattern
  while maxsplit ~= 0 do
    local curpos = 1
    local found = string.find(s, pattern)
    if found ~= nil then
      table.insert(t, string.sub(s, curpos, found - 1))
      curpos = found + patsz
      s = string.sub(s, curpos)
    else
      table.insert(t, string.sub(s, curpos))
      break
    end
    maxsplit = maxsplit - 1
    if maxsplit == 0 then
      table.insert(t, string.sub(s, curpos - patsz - 1))
    end
  end
  return t
end

