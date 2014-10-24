# Yana-server


## Plugins

### Plugin Domoticz

## Backup
sudo /var/www/yana-server/yana_backup.sh

### cron
Sinon pour declencher ça à 6H du matin, un petit

sudo crontab -e

puis coller

0 6 * * * sudo sudo /var/www/yana-server/yana_backup.sh

