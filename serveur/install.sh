#!/bin/bash
# Mon script "installation"  Raspbian
#

if [[ $EUID -ne 0 ]]; then
   echo "Vous devez être root" 1>&2
   echo "Try: sudo "$0 1>&2
   exit 1
fi

# Mise a jour 
#------------


#echo "Mise a jour du systeme"
#apt-get upgrade
# upgrade packages
echo -e "\033[33m>>> upgrading installed packages...\033[0m"
sudo apt-get update
sudo apt-get -y upgrade


if ! which git > /dev/null; then
	echo -e "\033[33m>>> installing git...\033[0m"
	sudo apt-get update
	sudo apt-get -y install git
fi



cd /var/www/
git clone https://github.com/ldleman/yana-server.git



sudo apt-get install fail2ban


#sudo nano /etc/ssh/sshd_config

#PermitRootLogin no


# raspAdmin
git clone https://github.com/air01a/raspadmin.git
cd raspadmin
sudo ./installer


# transmission
apt-get install transmission-daemon


#nano /etc/transmission-daemon/settings.json
# TODO conf transmission


invoke-rc.d transmission-daemon reload



# git private repo http://blog.meinside.pe.kr/Gogs-on-Raspberry-Pi/ http://gogs.io/docs/installation/configuration_and_run.md

# create git user

wget https://raw.githubusercontent.com/meinside/rpi-configs/master/bin/prep_go.sh

echo "see http://blog.meinside.pe.kr/Gogs-on-Raspberry-Pi/ "

su git
cd ~

echo "# for go" >> .bashrc
echo "if [ -d /opt/go/bin ]; then" >> .bashrc
echo "  export GOROOT=/opt/go" >> .bashrc
echo "  export GOPATH=$HOME/srcs/go" >> .bashrc
echo "  export PATH=$PATH:$GOROOT/bin" >> .bashrc
echo "fi" >> .bashrc



# cleanup
echo -e "\033[33m>>> cleaning up...\033[0m"
sudo apt-get -y autoremove
sudo apt-get -y autoclean