commandArray = {}


if (devicechanged['POWER_OFF_RASPBOX'] == 'Off') then
    print('Turning off RaspBox')
    result = os.execute("/home/pi/domoticz/scripts/sh/power_off_raspbox.sh")
    print(result)
end

return commandArray