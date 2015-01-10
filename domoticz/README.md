# Domoticz

## Configuration Usb
- 98-usb-serial.rules

cp 98-usb-serial.rules /etc/udev/rules.d/98-usb-serial.rules

Donner un nom persistant au devices usb

Détails sur [Domoticz usb](http://domoticz-raspberry.xoo.it/t38-DOMOTICZ-RASPBERRY-PI-ET-Z-WAVE.htm)

## lirc
Utilisation d'emetteur et recepteur infrarouge pour interagir avec nos télécommandes et domoticz.

TODO

## Backup
Sinon pour declencher ça à 6H du matin, un petit

sudo crontab -e

puis coller

0 6 * * * sudo /home/pi/domoticz/scripts/domoticz_backup.sh

## Scripts
- divers scripts lua,python,perl,sh pour domoticz

## LUA

script_device_kodi.lua
script_device_lgtv.lua
script_device_marantz.lua

script_device_termostat.lua

## Perl

ping_by_ip.pl : permet de mettre à jour certains switch pour indiquer que les équipents repondent au ping

## Python

kodi_end.py :  calcul la durée restante d'une film en cours de lecture sur Kodi et met à jours une uservariable sur domoticz
marantz.py : permet de piloter certaines fonction d'un ampli Marantz
domoticz.py : permet de mettre à jours certains switchs ou uservariables de domoticz

## Sh
TODO
## WWW

### Custom icons
retrouver dans le dossiers images, des icones supplémentaires pour domoticz, avec le fichier switch_icons.txt qui correspond


### Templates
non fonctionnel