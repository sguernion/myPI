<?php

require_once('XbmcCmd.class.php');

// Suppression de la table du plugin
$table = new XbmcCmd();
//$table->drop();

$execQuery = $table->query('DROP TABLE yana_plugin_xbmc');

$table_configuration = new configuration();
$table_configuration->delete(array('key'=>'plugin_xbmcCmd_api_url_xbmc'));
$table_configuration->delete(array('key'=>'plugin_xbmcCmd_api_timeout_xbmc'));
$table_configuration->delete(array('key'=>'plugin_xbmcCmd_api_recognition_status'));

// suppression de la piece XBMC
$table_room = new Room();
$table_room->delete(array('name'=>'XBMC'));

// Recuperation de l'id et Suppression de la section
$table_section = new Section();
$id_section = $table_section->load(array("label"=>"xbmc"))->getId();
$table_section->delete(array('label'=>'xbmc'));
        
// suppression des droits correspondant à la section
$table_right = new Right();
$table_right->delete(array('section'=>$id_section)); 

?>