commandArray = {}


if (devicechanged['D_RASPBOX_POWEROFF'] == 'Off') then
    print('Turning off RaspBox')
    result = os.execute("/home/pi/domoticz/scripts/sh/power_off_raspbox.sh")
    print(result)
end

return commandArray