<?php

class MarantzPlugin{
	private $section="marantz";
	protected $conf;
	
	function __construct($conf){
		$this->conf = $conf;
	}
	
	function actions($_,$myUser){
		if($myUser==false) exit('Vous devez vous connecter pour cette action.');
		switch($_['action']){
				case 'marantz_plugin_setting':
					$this->action_plugin_setting($_);
				break;
		}
	
	}
	
	function action_plugin_setting($_){
			if(isset($_['ip'])){
				$this->conf->put('plugin_marantz_ip',$_['ip']);
			}
			if(isset($_['port'])){
				$this->conf->put('plugin_marantz_port',$_['port']);
			}
			header('location:setting.php?section=preference&block='+$this->section.'');
	}

}

?>