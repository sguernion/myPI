commandArray = {}


user="user"
pw="password"
port="80"
host="192.168.0.10"

if (devicechanged['Xbmc'] == 'Off') then
        print('Turning off XBMC')
        commandArray['OpenURL']='http://'.. user .. ':'.. pw ..'@'.. host ..':'.. port ..'/jsonrpc?request={"jsonrpc":"2.0","method":"System.Shutdown","id":1}?'
        commandArray['Multimedia']='Off After 150'
end

 return commandArray