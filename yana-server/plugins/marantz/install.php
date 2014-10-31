<?php
  
require_once('MarantzCmd.class.php');

$table = new MarantzCmd();
$table->create();  
  
$conf = new Configuration();
$conf->put('plugin_marantz_ip','192.168.0.11');
$conf->put('plugin_marantz_port','80');
$conf->put('plugin_marantz_zone','MainZone')
?>