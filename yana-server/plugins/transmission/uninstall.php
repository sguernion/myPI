<?php


$conf = new Configuration();
$conf->delete(array('key'=>'conf:plugin_transmission_ip'));
$conf->delete(array('key'=>'conf:plugin_transmission_port'));
$conf->delete(array('key'=>'conf:plugin_transmission_user'));
$conf->delete(array('key'=>'conf:plugin_transmission_pswd'));


?>