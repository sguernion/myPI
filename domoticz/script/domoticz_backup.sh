#!/bin/bash

### Backup script v0.3 beta
### Please be sure all dependencies are satisfied.
### Needed packages:
### - sshpass
### - sendemail
### - dropbox_uploader by Andrea Fabrizi
###                    https://github.com/andreafabrizi/Dropbox-Uploader
### patch for smtp ssl: http://raspberrypi.stackexchange.com/questions/2118/sendemail-failure
 
 
### USER CONFIGURABLE PARAMETERS
 
MODE="dropbox"                          # available modes: scp, ftp, mail, local, dropbox
 
# LOCAL/FTP/SCP/MAIL PARAMETERS
SERVER="SMTP.SERVER.TLD"                # used for: ftp mail scp
USERNAME="USERNAME"                     # used for: ftp mail scp
PASSWORD="PASSWORD"                     # used for: ftp mail scp
PORT="587"                              # used for: mail scp
WHERE="."                               # used for: mail scp
RCPT="DESTINATION MAIL ADDRESS"         # used for: mail
DESTDIR="/opt/backup"                   # used for: local
 
### END OF USER CONFIGURABLE PARAMETERS
 
 
DOMO_IP=192.168.0.17
DOMO_PORT=8080
 
TIMESTAMP=`/bin/date +%Y%m%d%H%M%S`
BACKUPFILE="domoticz_$TIMESTAMP.db"
BACKUPFILEGZ="$BACKUPFILE".gz
 
 
/usr/bin/curl -s http://$DOMO_IP:$DOMO_PORT/backupdatabase.php > /var/tmp/$BACKUPFILE
gzip -9 /var/tmp/$BACKUPFILE

DOMO_SCRIPT_PATH="/home/pi/domoticz/scripts"
# le nom du fichier de backup des scripts scripts_domoticz_AAMMJJHHMMSS
SCRIPT_FILE="scripts_domoticz"

## Sauvegarde des repertoires et ss rep des scripts
BACKUP_SCRIPT_FILEGZ="$SCRIPT_FILE$TIMESTAMP.gz"
cd $DOMO_SCRIPT_PATH
cd ..
tar zcvf /var/tmp/$BACKUP_SCRIPT_FILEGZ scripts/
 
echo "backup Mode $MODE"
 
case $MODE in
  scp)
    /usr/bin/sshpass -p $PASSWORD /usr/bin/scp -P $PORT /var/tmp/$BACKUPFILEGZ $USERNAME@$SERVER:$WHERE
	/usr/bin/sshpass -p $PASSWORD /usr/bin/scp -P $PORT /var/tmp/$BACKUP_SCRIPT_FILEGZ $USERNAME@$SERVER:$WHERE
  ;;
 
  ftp)
    curl -s --disable-epsv -v -T"/var/tmp/$BACKUPFILEGZ" -u"$USERNAME:$PASSWORD" "ftp://$SERVER/"
	curl -s --disable-epsv -v -T"/var/tmp/$BACKUP_SCRIPT_FILEGZ" -u"$USERNAME:$PASSWORD" "ftp://$SERVER/"
  ;;
 
  local)
    echo local
    cp /var/tmp/$BACKUPFILEGZ $DESTDIR
	cp /var/tmp/$BACKUP_SCRIPT_FILEGZ $DESTDIR
    echo "Your local copy of database is now on $DESTDIR"
  ;;
 
  mail)
    /usr/bin/sendemail -f $RCPT -t $RCPT -u "Mail from Domoticz" -m "Backup of Domoticz DB" -s $SERVER:$PORT -o tls=yes -xu $USERNAME -xp $PASSWORD -a /var/tmp/$BACKUPFILEGZ
 
  ;;
 
  dropbox)
    /opt/bin/dropbox_uploader.sh upload /var/tmp/$BACKUPFILEGZ /$BACKUPFILEGZ
	/opt/bin/dropbox_uploader.sh upload /var/tmp/$BACKUP_SCRIPT_FILEGZ /$BACKUP_SCRIPT_FILEGZ
  ;;
 
esac
 
/bin/rm /var/tmp/$BACKUPFILEGZ
/bin/rm /var/tmp/$BACKUP_SCRIPT_FILEGZ