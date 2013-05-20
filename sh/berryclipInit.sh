#!/bin/sh
# /etc/init.d/berryclipInit
# Description: Starts Python scripts
# ------------
#
### BEGIN INIT INFO
# Provides:          berryclipInit
# Required-Start:    $local_fs $remote_fs $network
# Required-Stop:     $local_fs $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description: Start Python scripts to init berryClip
### END INIT INFO

case $1 in
  start)
    # echo -n "Starting init berryClip: "
sudo python /usr/local/bin/berryclipInit.py
;;
  stop)
# echo -n "Stoping init berryClip "
sudo python /usr/local/bin/berryclipInit.py
;;
  restart)
# echo -n "Retarting init berryClip: "
sudo python /usr/local/bin/berryclipInit.py
;;
  *)
# echo "Usage: scripts {start|stop|restart}"
exit 1
esac