<?php
require_once('DomoticzCmd.class.php');

$table = new DomoticzCmd();
$table->drop();

$conf = new Configuration();
$conf->delete(array('key'=>'conf:plugin_domoticz_ip'));
$conf->delete(array('key'=>'conf:plugin_domoticz_port'));
$conf->delete(array('key'=>'conf:plugin_domoticz_user'));
$conf->delete(array('key'=>'conf:plugin_domoticz_pswd'));
$conf->delete(array('key'=>'conf:plugin_domoticz_plugins_devices'));

//TODO delete widget
?>