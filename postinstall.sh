#!/bin/bash
# Mon script "post installation"  Raspbmc
#

# Mise a jour 
#------------

echo "Mise a jour de la liste des depots"
sudo apt-get update

#echo "Mise a jour du systeme"
#sudo apt-get upgrade


echo "Installation..."

sudo apt-get install git

# bluetooth
sudo apt-get install bluetooth bluez
sudo service bluetooth start
#hcitool scan

# Python
sudo apt-get install python-dev python-setuptools
wget http://python-distribute.org/distribute_setup.py
python distribute_setup.py
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
sudo python get-pip.py
rm ./get-pip.py
rm ./distribute_setup.py
pip install rpi.gpio

# Pytomation
git clone https://github.com/zonyl/pytomation.git
cd pytomation
pip install -r requirements.txt
sudo chmod +x install.sh
sudo install.sh

# Python Wiimote
sudo apt-get install python-cwiid

# synthese vocal
sudo apt-get install festival flite

# sons
sudo apt-get install alsa-utils mpg321

#sudo modprobe snd-bcm2835
#sortie jack 
#sudo amixer cset numid=3 1
#sortie hdmi 
#sudo amixer cset numid=3 2
#volume
#amixer cset numid=3 -- 70%


#sudo initctl start xbmc
#sudo initctl stop xbmc

echo "Installation...done"

# wget scripts