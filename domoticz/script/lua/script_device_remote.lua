commandArray = {}

package.path = package.path..";/home/pi/domoticz/scripts/lua/modules/?.lua"
package.path = package.path..";/usr/local/lib/luarocks/rocks/?.lua"
require 'functions_utils'
require 'functions_custom'

json = require('cjson')



function read_file (fileName)
  output=''
  for line in io.lines(fileName) do
      output= output..line 
  end
  return output
end

--TODO read lirc_conf.json
lircConf=read_file ("/home/pi/domoticz/scripts/lirc_conf.json")


obj, pos, err = json:decode(lircConf,1,nil)
if err then
   print ("Error:", err)
else
   print(obj.remotes[0].remote)


end
