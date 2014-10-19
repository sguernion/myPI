<?php
 
require_once('DomoticzCmd.class.php');

$table = new DomoticzCmd();
$table->create();
 
$conf = new Configuration();
$conf->put('plugin_domoticz_ip','localhost');
$conf->put('plugin_domoticz_port','8080');
?>