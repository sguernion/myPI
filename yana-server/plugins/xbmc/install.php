<?php
require_once('XbmcCmd.class.php');
$table = new XbmcCmd();
$table->create();

$s1 = New Section();
$s1->setLabel('xbmc');
$s1->save();

$r1 = New Right();
$r1->setSection($s1->getId());
$r1->setRead('1');
$r1->setDelete('1');
$r1->setCreate('1');
$r1->setUpdate('1');
$r1->setRank('1');
$r1->save();

$conf = new Configuration();
$conf->put('plugin_xbmcCmd_api_url_xbmc','http://192.168.1.107:85/jsonrpc');
$conf->put('plugin_xbmcCmd_api_timeout_xbmc',5);
$conf->put('plugin_xbmcCmd_api_recognition_status','');


$ro = New Room();
$ro->setName('XBMC');
$ro->setDescription('De la bonne zic, un bon p\'tit film....');
$ro->save();

$roomManager = new Room();
$rooms = $roomManager->populate();
foreach($rooms as $room){
     if($room->getName() == "XBMC"){ $xbmcRoomId = $room->getId(); }    
}

$id=0;

$xbmc = New XbmcCmd();
$xbmc->setName('à droite');
$xbmc->setDescription('se déplacer à droite');
$xbmc->setJson('"method":"Input.Right","id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('à gauche');
$xbmc->setDescription('se déplacer à gauche');
$xbmc->setJson('"method":"Input.Left","id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('en haut');
$xbmc->setDescription('se déplacer en haut');
$xbmc->setJson('"method":"Input.Up","id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('en bas');
$xbmc->setDescription('se déplacer en bas');
$xbmc->setJson('"method":"Input.Down","id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('ok');
$xbmc->setDescription('valider');
$xbmc->setJson('"method":"Input.Select","id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('retour');
$xbmc->setDescription('retour en arrière');
$xbmc->setJson('"method":"Input.Back","id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('info');
$xbmc->setDescription('afficher les infos');
$xbmc->setJson('"method":"Input.Info","id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('menu principal');
$xbmc->setDescription('afficher le menu principal');
$xbmc->setJson('"method":"Input.Home","id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('coupe le son');
$xbmc->setDescription('je coupe le son...');
$xbmc->setJson('"method":"Application.SetMute","params":{"mute":"toggle"},"id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('remet le son');
$xbmc->setDescription('...et je remets le son');
$xbmc->setJson('"method":"Application.SetMute","params":{"mute":"toggle"},"id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('volume trente');
$xbmc->setDescription('volume du son à 30%');
$xbmc->setJson('"method":"Application.SetVolume","params":{"volume":30},"id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('volume cinquante');
$xbmc->setDescription('volume du son à 50%');
$xbmc->setJson('"method":"Application.SetVolume","params":{"volume":50},"id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('volume soixante dix');
$xbmc->setDescription('volume du son à 70%');
$xbmc->setJson('"method":"Application.SetVolume","params":{"volume":70},"id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('volume cent');
$xbmc->setDescription('volume du son à 100%');
$xbmc->setJson('"method":"Application.SetVolume","params":{"volume":100},"id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('reprise');
$xbmc->setDescription('lecture du media apres une pause ');
$xbmc->setJson('"method":"Player.PlayPause","params":{"playerid":0},"id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('pause');
$xbmc->setDescription('mettre en pause le media');
$xbmc->setJson('"method":"Player.PlayPause","params":{"playerid":0},"id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();


$xbmc = New XbmcCmd();
$xbmc->setName('suivant');
$xbmc->setDescription('média suivant');
$xbmc->setJson('"method":"Player.GoTo","params":{"playerid":0,"to":"next"},"id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('précédant');
$xbmc->setDescription('media précédent');
$xbmc->setJson('"method":"Player.GoTo","params":{"playerid":0,"to":"previous"},"id":"1"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

$xbmc = New XbmcCmd();
$xbmc->setName('info lecture en cours');
$xbmc->setDescription('donne des infos');
$xbmc->setJson('"method":"Player.GetItem","params":{"properties":["title","streamdetails"],"playerid":0},"id":"AudioGetItem"');
$xbmc->setConfidence('0.8');
$xbmc->setRoom($xbmcRoomId);
$xbmc->save();

?>
