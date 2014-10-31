<?php
require_once('MarantzAPI.class.php');
require_once('MarantzCmd.class.php');


class MarantzPlugin{
	private $section="marantz";
	protected $conf;
	
	function __construct($conf){
		$this->conf = $conf;
	}
	
	function actions($_,$myUser){
		
		if($myUser==false){ header('location:index.php?connexion=ko');}
		$marantzApi = new MarantzAPI($this->conf);
		switch($_['action']){
				case 'marantz_plugin_setting':
					$this->action_plugin_setting($_);
				break;
				case 'marantz_add':
					$this->action_add($_);
				break;
				case 'marantz_delete':
					$this->action_delete($_);
				break;
				case 'marantz_enable':
					$this->action_enable($_);
				break;
				case 'marantz_vocale':
					$this->action_vocale($_);
				break;
				
				case 'marantz_vocale_action_vup':
					$marantzApi->volume_up();
					$affirmation = 'Je monte le son';
				break;
				case 'marantz_vocale_action_vdown':
					$marantzApi->volume_down();
					$affirmation = 'Je baisse le son';
				break;
				case 'marantz_vocale_action_muteon':
					$marantzApi->mute_on();
					$affirmation = 'Je coupe le son';
				break;
				case 'marantz_vocale_action_muteoff':
					$marantzApi->mute_off();
					$affirmation = 'Je remet le son';
				break;
				case 'marantz_vocale_action_pon':
					$marantzApi->power_on();
					$affirmation = 'Ampli allumer';
				break;
				case 'marantz_vocale_action_poff':
					$marantzApi->power_off();
					$affirmation = 'Ampli eteint';
				break;
				case 'marantz_vocale_action_volume':
					$marantzApi->change_volume($_['decibel']);
					$affirmation = 'Volume '.$_['volume'];
				break;
				case 'marantz_vocale_action_source':
					$marantzApi->change_source($_['source']);
					$affirmation = 'Source '.$_['sourceName'];
				break;
		}
		
		if(0 === strpos($_['action'], 'marantz_vocale_action_')){
			$response = array('responses'=>array(
									  array('type'=>'talk','sentence'=>$affirmation)
								));
			$json = json_encode($response);
			echo ($json=='[]'?'{}':$json); 
			exit;
		}
	
	}
	
	function action_vocale($_){
		$marantz = new MarantzCmd();
		$marantz = $marantz->load(array('id'=>$_['id']));
		
		$marantzApi = new MarantzAPI($this->conf);
		$marantzApi->sendCmd($marantz->getParametre());
		
		$reponses = explode(';',$marantz->getReponses());
		$affirmation = $reponses[rand(0,count($reponses)-1)];
		$response = array('responses'=>array(
									  array('type'=>'talk','sentence'=>$affirmation)
								));
		$json = json_encode($response);
		echo ($json=='[]'?'{}':$json); 
		exit;
	}
	
	function action_enable($_){
		$marantz = new MarantzCmd();
		$marantz = $marantz->load(array('id'=>$_['id']));
					
		if ($marantz->getVocal() ==1) 
		{ 
			$marantz->setVocal(0);
		}
		elseif ($marantz->getVocal() ==0)
		{ 
			$marantz->setVocal(1);
		}
		$marantz->save();
		header('location:setting.php?section='.$this->section.'&block=cmd&save=ok');
	}
	
	function action_plugin_setting($_){
			if(isset($_['ip'])){
				$this->conf->put('plugin_marantz_ip',$_['ip']);
			}
			if(isset($_['port'])){
				$this->conf->put('plugin_marantz_port',$_['port']);
			}
			header('location:setting.php?section=preference&block='.$this->section.'');
	}
	
	function action_delete($_){
		$marantz = new MarantzCmd();
		$marantz->delete(array('id'=>$_['id']));
		header('location:setting.php?section='.$this->section.'&block=cmd');
	}
	
	function action_add($_){
		global $conf;
		if(isset($_['uid'])){
			foreach($this->predefined_commands('action.php') as $cmd){
				if($_['uid'] == $cmd['uid']){
					$marantz = new MarantzCmd();
					$marantz->setName($cmd['name']);
					$marantz->setCmd($cmd['command']);
					$marantz->setParametre($cmd['parametre']);
					$marantz->setConfidence($cmd['confidence']);
					$marantz->setZone($conf->get['plugin_marantz_zone']);
					$marantz->setReponses($cmd['reponses']);
					$marantz->setVocal(true);
					$marantz->save();
					
				}
				
			}
		
		}else{
				
					$marantz = new MarantzCmd();
					$marantz->setName($_['name']);
					$marantz->setCmd($_['cmd']);
					$marantz->setParametre($_['parametre']);
					$marantz->setConfidence($_['confidence']);
					$marantz->setReponses($_['reponses']);
					$marantz->setZone($conf->get['plugin_marantz_zone']);
					$marantz->setVocal(true);
					$marantz->save();
				
				}
					header('location:setting.php?section='.$this->section.'&block=new&save=ok');
				
		
		
	}



function predefined_commands($actionUrl){
	$commands[]=array(
					'name'=>'volume Up',
					'uid'=>'volup',
					'command'=>' Monte le son',
					'url'=> $actionUrl.'?action=marantz_vocale_action_vup',
					'parametre'=>'PutMasterVolumeBtn%2F%3E',
					'reponses'=>'Volume up;Je monte le son',
					'confidence'=>'0.8');
	$commands[]=array(
				'name'=>'volume down',
				'uid'=>'voldown',
				'command'=>' Baisse le son',
				'parametre'=>'PutMasterVolumeBtn%2F%3C',
				'reponses'=>' Je baisse le son',
				'url'=> $actionUrl.'?action=marantz_vocale_action_vdown','confidence'=>'0.8');
				
	$commands[] = array(
				'name'=>'Mute',
				'uid'=>'mute',
				'command'=>' Coupe le son',
				'parametre'=>'PutVolumeMute%2Fon',
				'reponses'=>' Je coupe le son;Mute',
				'url'=> $actionUrl.'?action=marantz_vocale_action_muteon','confidence'=>'0.8');	
				
	$commands[] = array(
				'name'=>'Mute off',
				'uid'=>'unmute',
				'command'=>' Remet le son',
				'parametre'=>'PutVolumeMute%2Foff',
				'reponses'=>' Je remet le son',
				'url'=> $actionUrl.'?action=marantz_vocale_action_muteoff','confidence'=>'0.8');	

	$commands[] = array(
				'name'=>'Power off',
				'uid'=>'off',
				'command'=>' Ampli Off',
				'parametre'=>'PutZone_OnOff%2FOFF',
				'reponses'=>' Ampli eteint',
				'url'=> $actionUrl.'?action=marantz_vocale_action_poff','confidence'=>'0.8');	

	$commands[] = array(
				'name'=>'Power on',
				'uid'=>'on',
				'command'=>' Ampli On',
				'parametre'=>'PutZone_OnOff%2FON',
				'reponses'=>' Ampli On',
				'url'=> $actionUrl.'?action=marantz_vocale_action_pon','confidence'=>'0.8');

	$commands[] = array(
				'name'=>'Tuner',
				'uid'=>'tuner',
				'command'=>' Source Tuner',
				'parametre'=>'PutZone_InputFunction%2FTUNER',
				'reponses'=>'Source Tuner;En avant la musique',
				'url'=> $actionUrl.'?action=marantz_vocale_action_source&source=TUNER&sourceName=Tuner','confidence'=>'0.8');
				
	$commands[] = array(
				'name'=>'Tv',
				'uid'=>'tv',
				'command'=>' Source Tv',
				'parametre'=>'PutZone_InputFunction%2FTV',
				'reponses'=>'Source TV',
				'url'=> $actionUrl.'?action=marantz_vocale_action_source&source=TV&sourceName=Tv','confidence'=>'0.8');
				
	$commands[] = array(
				'name'=>'Satelite',
				'uid'=>'sat',
				'command'=>' Source Satelite',
				'parametre'=>'PutZone_InputFunction%2FSAT/CBL',
				'reponses'=>'Source Sat',
				'url'=> $actionUrl.'?action=marantz_vocale_action_source&source=SAT/CBL&sourceName=Satelite','confidence'=>'0.8');
				
	$commands[] = array(
				'name'=>'Volume 40',
				'uid'=>'vol40',
				'command'=>' volume a 40',
				'parametre'=>'PutMasterVolumeSet%2F-40',
				'reponses'=>'Volume 40',
				'url'=> $actionUrl.'?action=marantz_vocale_action_volume&decibel=-40&volume=40','confidence'=>'0.8');
	$commands[] = array(
				'name'=>'Volume 50',
				'uid'=>'vol50',
				'command'=>' volume a 50',
				'parametre'=>'PutMasterVolumeSet%2F-30',
				'reponses'=>'Volume 50',
				'url'=> $actionUrl.'?action=marantz_vocale_action_volume&decibel=-30&volume=50','confidence'=>'0.8');
				
	$commands[] = array(
				'name'=>'Volume 30',
				'uid'=>'vol30',
				'command'=>' volume a 30',
				'parametre'=>'PutMasterVolumeSet%2F-50',
				'reponses'=>'Volume 30',
				'url'=> $actionUrl.'?action=marantz_vocale_action_volume&decibel=-50&volume=30','confidence'=>'0.8');
					
	return $commands;
}
}
?>