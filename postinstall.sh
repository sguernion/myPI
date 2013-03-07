#!/bin/bash
# Mon script "post installation"  Raspbmc
#

# Mise a jour 
#------------

echo "Mise a jour de la liste des depots"
apt-get update

echo "Mise a jour du systeme"
apt-get upgrade


echo "Installation..."

apt-get install git

# bluetooth
apt-get install bluetooth bluez
sudo service bluetooth start
#hcitool scan

# Python Wiimote
apt-get install python-cwiid

# synthese vocal
sudo apt-get install festival flite

# sons
sudo apt-get install alsa-utils mpg321

#sudo modprobe snd-bcm2835
#sudo amixer cset numid=3 1
#amixer cset numid=3 -- 70%


#sudo initctl start xbmc
#sudo initctl stop xbmc

echo "Installation...done"

# wget scripts