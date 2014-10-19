<?php

class DomoticzApi {

	protected $conf;
	
	//0 = Integer, e.g. -1, 1, 0, 2, 10 
	//1 = Float, e.g. -1.1, 1.2, 3.1
	//2 = String
	//3 = Date in format DD/MM/YYYY
	//4 = Time in 24 hr format HH:MM
	protected $variableType = array('Integer','Float','String','Date','Time');


	
	function __construct($conf){
		$this->conf = $conf;
	}
	
	function getUrl(){
		$url = 'http://';
		$url .=	$this->conf->get('plugin_domoticz_user').':'.$this->conf->get('plugin_domoticz_pswd').'@';
		$url .=	$this->conf->get('plugin_domoticz_ip').':'.$this->conf->get('plugin_domoticz_port');
		return $url;
	}
	
	function getDevices(){
			$lights = $this->getSwitches();
			$scenes = $this->getScenes();
			$temps = $this->getTemp();
			$variables = $this->getUserVariables();
			$devices = array_merge($lights,$scenes,$temps,$variables);
			return $devices;
		
	}
	
	
	
	function getInfo($id){
		$url =  $this->getUrl();
		$url .=	'/json.htm?type=devices&rid='.$id;
		$infos = json_decode(file_get_contents($url), true);
		return $infos['result'][0];
	}

	function getSwitches(){
		// Get all lights/switches
		$lights_url =  $this->getUrl();
		$lights_url .=	'/json.htm?type=command&param=getlightswitches';
		$lights = json_decode(file_get_contents($lights_url), true);
		$devices = array();
		if (is_array($lights)){
			foreach($lights as $row){
				if (is_array($row)){
					foreach($row as $row2){
						$row2['categorie']="switch";
						$devices[] =$row2;
		}}}}
		
		return $devices;
	}
	
	function setState($type,$ix,$state){
				$url = $this->getUrl();
				$url .= '/json.htm?type=command&param='.$type.'&idx='.urlencode($ix).'&switchcmd='.$state.'&level=0';
				$ch = curl_init($url);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 3);
				curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; fr-FR; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1" ); 
				$c = curl_exec($ch);
                curl_close($ch);
	
	}
	
	function getScenes(){
		// Get all scenes/groups
		$scenes_url =  $this->getUrl();
		$scenes_url .= '/json.htm?type=scenes';
		$scenes = json_decode(file_get_contents($scenes_url), true);
		$devices = array();
		if (is_array($scenes)){
			foreach($scenes as $row){
				if (is_array($row)){
					foreach($row as $row2){
						$row2['categorie']="scene";
						$devices[] =$row2;
		}}}}
		
		return $devices;
	}
	
	
	function getTemp(){
		// Get all temps
		$temps_url =  $this->getUrl();
		$temps_url .=	'/json.htm?type=devices&filter=temp&used=true&order=Name';
		$temps = json_decode(file_get_contents($temps_url), true);
		$devices = array();
		if (is_array($temps)){
			foreach($temps as $row){
				if (is_array($row)){
					foreach($row as $row2){
						$row2['categorie']="mesure";
						$devices[] =$row2;
		}}}}
		
		return $devices;

	}
	
	function getUserVariables(){
		// Get all uservariables
		$url =  $this->getUrl();
		$url .=	'/json.htm?type=command&param=getuservariables';
		$variables = json_decode(file_get_contents($url), true);
		$devices = array();
		if (is_array($variables)){
			foreach($variables as $row){
				if (is_array($row)){
					foreach($row as $row2){
						$row2['categorie']="variable";
						$row2['Type']=$this->variableType[$row2['Type']];
						$devices[] =$row2;
		}}}}
		
		return $devices;

	}
	
	function getUserVariable($id){
		$url =  $this->getUrl();
		$url .=	'/json.htm?type=command&param=getuservariable&idx='.$id;
		$infos = json_decode(file_get_contents($url), true);
		return $infos['result'][0];
	}

}



?>