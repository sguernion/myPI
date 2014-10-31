<?php
require_once('MarantzCmd.class.php');

$table = new MarantzCmd();
$table->drop();

$conf = new Configuration();
$conf->getAll();
$conf->remove('ip','marantz');
$conf->remove('port','marantz');
$conf->remove('zone','marantz');
?>