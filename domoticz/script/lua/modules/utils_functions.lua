
package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
require 'xbmc_api'

-- 
-- Envoie d'un sms sur un mobile Free
function send_sms (user,key,message)
	commandArray['OpenURL']='https://smsapi.free-mobile.fr/sendmsg?user='..user..'&pass='..key..'&msg='..message
end


function send_vocal (message)
	os.execute('./speak.sh ' .. message)
	os.execute('wait 10 ')
end

function send_xbmc_cmd (user,pw,host,port,request)
	commandArray['OpenURL']='http://'..user.. ':'.. pw ..'@'.. host ..':'.. port ..'/jsonrpc?request='.. request
end



function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- calcul du temps en seconde depuis la derniere mise a jour du capteur
function time_difference (device)
	t1 = os.time()
	s = otherdevices_lastupdate[device]
	-- returns a date time like 2013-07-11 17:23:12

	year = string.sub(s, 1, 4)
	month = string.sub(s, 6, 7)
	day = string.sub(s, 9, 10)
	hour = string.sub(s, 12, 13)
	minutes = string.sub(s, 15, 16)
	seconds = string.sub(s, 18, 19)


	t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
	return (os.difftime (t1, t2))
end

function read_file (fileName)
  property = {}
  for line in io.lines(fileName) do
    for key, value in string.gmatch(line, '(.-)=(.-)$') do 
      property[key] = value 
    end
  end
  return property
end

 function ping_alive (device,ip)
	if (ip  ~= nil and ip  ~= '') then
		 ping_success=os.execute('ping -c1 ' .. ip)
		 if ping_success then
			if ( otherdevices[device] == 'Off') then
				commandArray[device]='On'
			end
		 else
		  if (otherdevices[device] == 'On') then
			commandArray[device]='Off'
		  end
		 end
	else
		print(" ip null for device ".. device )
	end
		  return commandArray[device]
 end
 
function split (s, pattern, maxsplit)
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




function xbmc_notification (message)
	properties = read_file ("/home/pi/domoticz/scripts/lua/config.properties")
	user=trim(properties['xbmc.user'])
	pw=trim(properties['xbmc.password'])
	port=trim(properties['xbmc.port'])
	host=trim(properties['xbmc.host'])
	xbmc = Xbmc.create(host,port,user,pw)
    xbmc.notification(message)
	--send_xbmc_cmd (user,pw,host,port,'{"jsonrpc":"2.0","method":"GUI.ShowNotification","params":{"title":"domoticz","message":"'..message..'","image":"","displaytime":15000},"id":1}')
end