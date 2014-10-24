# Xbmc
## Backup
sudo /home/pi/xbmc_backup.sh

### Cron
Sinon pour declencher ça à 6H du matin, un petit

sudo crontab -e

puis coller

0 6 * * * sudo /home/pi/xbmc_backup.sh
