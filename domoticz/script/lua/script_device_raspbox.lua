commandArray = {}

-- configurer ssh authorised_key for pi user
-- sudo chmod u+s /sbin/halt


if (devicechanged['P_RaspBox'] == 'Off') then
    print('Turning off RaspBox')
    result = os.execute('ssh pi@192.168.0.14 /sbin/halt')
    print(result)
end

return commandArray