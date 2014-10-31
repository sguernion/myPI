<?php
require_once('DomoticzCmd.class.php');

$table = new DomoticzCmd();
$table->drop();

$conf = new Configuration();
$conf->getAll();
$conf->remove('ip','domoticz');
$conf->remove('port','domoticz');
$conf->remove('user','domoticz');
$conf->remove('pswd','domoticz');
$conf->remove('widgets_devices','domoticz');

//TODO delete widget
?>