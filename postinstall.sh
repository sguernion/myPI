#!/bin/bash
# Mon script "post installation"  Raspbmc
#

if [[ $EUID -ne 0 ]]; then
   echo "Vous devez être root" 1>&2
   echo "Try: sudo "$0 1>&2
   exit 1
fi

# Mise a jour 
#------------

echo "Mise a jour de la liste des depots"
apt-get update

#echo "Mise a jour du systeme"
#apt-get upgrade


echo "Installation..."

apt-get -y install git

# bluetooth
apt-get -y install bluetooth bluez
service bluetooth start
#hcitool scan

# Python
apt-get -y install python-dev python-setuptools
wget http://python-distribute.org/distribute_setup.py
python distribute_setup.py
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py
rm ./get-pip.py
rm ./distribute_setup.py
pip install rpi.gpio

# Pytomation
git clone https://github.com/zonyl/pytomation.git
cd pytomation
pip install -r requirements.txt
chmod +x install.sh
install.sh

# Python Wiimote
apt-get -y install python-cwiid

# synthese vocal
apt-get -y install festival flite

# sons
apt-get -y install alsa-utils mpg321

#modprobe snd-bcm2835
#sortie jack 
#amixer cset numid=3 1
#sortie hdmi 
#amixer cset numid=3 2
#volume
#amixer cset numid=3 -- 70%


#initctl start xbmc
#initctl stop xbmc

#http://www.raspberrypi-spy.co.uk/2013/05/raspberry-pi-cpu-usage-monitoring-with-a-berryclip/
cd sh
wget http://www.raspberrypi-spy.co.uk/berryclip/6_led/berryclip_cpu_01.sh
chmod +x berryclip_cpu_01.sh

echo "Installation...done"

# wget scripts