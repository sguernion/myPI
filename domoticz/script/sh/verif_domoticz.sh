#!/bin/bash
# Script qui vérifie l'état de domoticz et qui relance si off

now=$(date) #récupération de la date et heure pour les logs

#Récupération du retour de la commande de status
domoticz=$(sudo service domoticz.sh status)

if [ "$domoticz" == "domoticz is not running ... failed!" ] # Si le service n'est pas lancé
then
 relance=$(sudo service domoticz.sh start) #On le lance
 echo "$now >> relance : $relance" #On log le lancement
else
 echo "$now >> Domoticz lance" #On log l'état normal
fi
exit 0