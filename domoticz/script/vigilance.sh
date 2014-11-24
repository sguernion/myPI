#!/bin/sh
#vigilance.sh
color=$(curl http://api.domogeek.fr/vigilance/35/color)
risk=$(curl http://api.domogeek.fr/vigilance/35/risk)
if [ $color = "vert" ]; then
col=1
elif [ $color = "jaune" ]; then
col=2
elif [ $color = "orange" ]; then
col=3
elif [ $color = "rouge" ]; then
col=4
#echo "subject: Vigilance" $color "risque de" $risk > /var/tmp/mail.txt
#echo >> /var/tmp/mail.txt
#curl --url "smtps://smtp.mail.x.com:465" --ssl-reqd --mail-from "expéditeur" --mail-rcpt "destinataire" --upload-file /var/tmp/mail.txt --user "adresse compte smtp:mot de passe"$
fi
curl http://192.168.0.17:8080/json.htm?type=command\&param=udevice\&idx=VOTRE IDX 99\&nvalue=$col\&svalue="$risk"