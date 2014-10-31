<?php
  
require_once('MarantzCmd.class.php');

$table = new MarantzCmd();
$table->create();  
  
$conf = new Configuration();
$conf->put('ip','192.168.0.11','marantz');
$conf->put('port','80','marantz');
$conf->put('zone','MainZone','marantz');
?>