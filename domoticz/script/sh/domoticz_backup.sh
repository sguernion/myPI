#!/bin/bash
source functions.sh
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
TEMPDIR="/var/opt/"
 
### END OF USER CONFIGURABLE PARAMETERS
DOMO_IP=$(read_properties $FILE_NAME "domoticz.ip")
DOMO_PORT=$(read_properties $FILE_NAME "domoticz.port")

echo $DOMO_IP
TIMESTAMP=`/bin/date +%Y%m%d%H%M%S`
BACKUPFILE="domoticz_$TIMESTAMP.db"
BACKUPFILEGZ="$BACKUPFILE".gz
 
 
/usr/bin/curl -s http://$DOMO_IP:$DOMO_PORT/backupdatabase.php > $TEMPDIR$BACKUPFILE
gzip -9 $TEMPDIR$BACKUPFILE

DOMO_SCRIPT_PATH="/home/pi/domoticz/scripts"
# le nom du fichier de backup des scripts scripts_domoticz_AAMMJJHHMMSS
SCRIPT_FILE="scripts_domoticz"

## Sauvegarde des repertoires et ss rep des scripts
BACKUP_SCRIPT_FILEGZ="$SCRIPT_FILE$TIMESTAMP.gz"
cd $DOMO_SCRIPT_PATH
cd ..
tar zcvf $TEMPDIR$BACKUP_SCRIPT_FILEGZ scripts/
 
echo "backup Mode $MODE"
 
case $MODE in
  scp)
    /usr/bin/sshpass -p $PASSWORD /usr/bin/scp -P $PORT $TEMPDIR$BACKUPFILEGZ $USERNAME@$SERVER:$WHERE
    /usr/bin/sshpass -p $PASSWORD /usr/bin/scp -P $PORT $TEMPDIR$BACKUP_SCRIPT_FILEGZ $USERNAME@$SERVER:$WHERE
  ;;
 
  ftp)
    curl -s --disable-epsv -v -T"$TEMPDIR$BACKUPFILEGZ" -u"$USERNAME:$PASSWORD" "ftp://$SERVER/"
    curl -s --disable-epsv -v -T"$TEMPDIR$BACKUP_SCRIPT_FILEGZ" -u"$USERNAME:$PASSWORD" "ftp://$SERVER/"
  ;;
 
  local)
    echo local
    cp $TEMPDIR$BACKUPFILEGZ $DESTDIR
	cp $TEMPDIR$BACKUP_SCRIPT_FILEGZ $DESTDIR
    echo "Your local copy of database is now on $DESTDIR"
  ;;
 
  mail)
    /usr/bin/sendemail -f $RCPT -t $RCPT -u "Mail from Domoticz" -m "Backup of Domoticz DB" -s $SERVER:$PORT -o tls=yes -xu $USERNAME -xp $PASSWORD -a $TEMPDIR$BACKUPFILEGZ
 
  ;;
 
  dropbox)
    /opt/bin/dropbox_uploader.sh upload $TEMPDIR$BACKUPFILEGZ /$BACKUPFILEGZ
    /opt/bin/dropbox_uploader.sh upload $TEMPDIR$BACKUP_SCRIPT_FILEGZ /$BACKUP_SCRIPT_FILEGZ
  ;;
 
esac
 
/bin/rm $TEMPDIR$BACKUPFILEGZ
/bin/rm $TEMPDIR$BACKUP_SCRIPT_FILEGZ
