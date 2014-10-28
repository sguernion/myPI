<?php
require_once('MarantzAPI.class.php');


class MarantzPlugin{
	private $section="marantz";
	protected $conf;
	
	function __construct($conf){
		$this->conf = $conf;
	}
	
	function actions($_,$myUser){
		
		if($myUser==false) exit('Vous devez vous connecter pour cette action.');
		$marantzApi = new MarantzAPI($this->conf);
		switch($_['action']){
				case 'marantz_plugin_setting':
					$this->action_plugin_setting($_);
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
	
	function action_plugin_setting($_){
			if(isset($_['ip'])){
				$this->conf->put('plugin_marantz_ip',$_['ip']);
			}
			if(isset($_['port'])){
				$this->conf->put('plugin_marantz_port',$_['port']);
			}
			header('location:setting.php?section=preference&block='.$this->section.'');
	}

}

?>