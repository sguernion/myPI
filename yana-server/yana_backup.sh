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
 
 
 
TIMESTAMP=`/bin/date +%Y%m%d%H%M%S`



XBMC_PATH="/var/www/yana-server"
# le nom du fichier de backup des scripts yana_backup_AAMMJJHHMMSS
BACKUP_FILE="yana_backup_"

## Sauvegarde des repertoires et ss rep des scripts
BACKUP_FILEGZ="$BACKUP_FILE$TIMESTAMP.gz"
cd $XBMC_PATH
cd ..
tar zcvf /var/tmp/$BACKUP_FILEGZ yana-server/ --exclude='classes/*' --exclude='log/*' --exclude='plugins/*' --exclude='templates/*' --exclude='*.html' --exclude='*.png'
 
echo "backup Mode $MODE"

case $MODE in
  scp)
    /usr/bin/sshpass -p $PASSWORD /usr/bin/scp -P $PORT /var/tmp/$BACKUP_FILEGZ $USERNAME@$SERVER:$WHERE
  ;;
 
  ftp)
    curl -s --disable-epsv -v -T"/var/tmp/$BACKUP_FILEGZ" -u"$USERNAME:$PASSWORD" "ftp://$SERVER/"
  ;;
 
  local)
    echo local
    cp /var/tmp/$BACKUP_FILEGZ $DESTDIR
    echo "Your local copy of database is now on $DESTDIR"
  ;;
 
  mail)
    /usr/bin/sendemail -f $RCPT -t $RCPT -u "Mail from Yana" -m "Backup of Yana DB" -s $SERVER:$PORT -o tls=yes -xu $USERNAME -xp $PASSWORD -a /var/tmp/$BACKUP_FILEGZ
 
  ;;
 
  dropbox)
    /opt/bin/dropbox_uploader.sh upload /var/tmp/$BACKUP_FILEGZ /$BACKUP_FILEGZ
  ;;
 
esac
 
/bin/rm /var/tmp/$BACKUP_FILEGZ