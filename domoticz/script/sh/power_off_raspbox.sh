#!/bin/bash

#configurer ssh authorised_key for pi user
#sudo chmod u+s /sbin/halt

source functions.sh


ip=$(read_properties $FILE_NAME "server.RaspBox.ip")
 
sudo -u pi sh -c 'ssh pi@$ip /sbin/halt'