<?php
require_once('MarantzCmd.class.php');

$table = new MarantzCmd();
$table->drop();

$conf = new Configuration();
$conf->delete(array('key'=>'conf:plugin_marantz_ip'));
$conf->delete(array('key'=>'conf:plugin_marantz_port'));
$conf->delete(array('key'=>'conf:plugin_marantz_zone'));
?>