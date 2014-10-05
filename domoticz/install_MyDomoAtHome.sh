#!/bin/bash


echo "## Install MyDomoAtHome : DOMO/ REST Gateway between Domoticz and Imperihome ##"

cd ~/domoticz/
git clone https://github.com/empierre/MyDomoAtHome MyDomoAtHome
cd MyDomoAtHome
cp config.yml.def config.yml
cp production.yml.def production.yml
cp development.yml.def development.yml

echo "##########"

# TODO Configuring the app
# TODO add service
# TODO Starting the application
#./start.sh

