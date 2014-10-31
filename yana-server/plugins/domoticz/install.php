<?php
 
require_once('DomoticzCmd.class.php');

$table = new DomoticzCmd();
$table->create();
 
$conf = new Configuration();
$conf->put('ip','localhost','domoticz');
$conf->put('port','8080','domoticz');
?>