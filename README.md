# My Raspberry Pi

Programmation avec une raspberry pi, découvrez les articles sur le [Blog](http://sguernion.github.io/)

## installation
le script postinstall.py, retrace les diffèrentes chose que j'ai du installer.
Cela me sert d'aide memoire si je doit repartir d'une image raspbmc toute fraîche


## BerryClip

Quelques [scripts](https://github.com/sguernion/myPI/tree/master/python/gpio) python d'utilisation de la carte BerryClip
 * alarm.py : utilisation du buzzer comme alarme, arret du son a l'aide du bouton
 * jenkins.py : affichage grace au leds du status d'un build jenkins
 * gmail.py : signale l'arrivé d'un mail
 * noel.py : quelques animation lumineuse grace aux leds
 * temp.py : affiche la temperation des la raspberry dans la console et affiche une tendance grace aux leds
 
## Bluetooh
TODO
### Wiimote
TODO

## Xbmc
### Backup
sudo /home/pi/xbmc_backup.sh


## Domotique
### Backup
Sinon pour declencher ça à 6H du matin, un petit

sudo crontab -e

puis coller

0 6 * * * sudo /home/pi/domoticz/scripts/domoticz_backup.sh

### Scripts
TODO
