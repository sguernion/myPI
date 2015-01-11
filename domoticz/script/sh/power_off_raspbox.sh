#!/bin/bash

#configurer ssh authorised_key for pi user
#sudo chmod u+s /sbin/halt
 
sudo -u pi sh -c 'ssh pi@192.168.0.14 /sbin/halt'