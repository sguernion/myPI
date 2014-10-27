<?php

class MarantzAPI{
	
	protected $conf;
	
	function __construct($conf){
		$this->conf = $conf;
	}

	function get($url){
		try {
				$ch = curl_init();
				$timeout = 5;
				curl_setopt($ch, CURLOPT_URL, $url);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
				curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
				$data = curl_exec($ch);
				curl_close($ch);
				$infos = json_decode($data, true);
				return $infos;
		}
		catch (Exception $e) {
			return array();
		}
	}
	
	function getUrl(){
		$url = 'http://';
		//$url .=	$this->conf->get('plugin_marantz_user').':'.$this->conf->get('plugin_marantz_pswd').'@';
		$url .=	$this->conf->get('plugin_marantz_ip').':'.$this->conf->get('plugin_marantz_port').'/'.$this->conf->get('plugin_marantz_zone').'/index.put.asp?';
		return $url;
	}
	
	function sendCmd($cmd){
		return $this->get($this->getUrl().'cmd0='.$cmd );
	}
	

	function change_source($source){
		return $this->sendCmd('PutZone_InputFunction%2F'.$source );
	}

	function change_volume($decibel){
		return $this->sendCmd('PutMasterVolumeSet%2F'.$decibel );
	}

	function volume_up(){
		return $this->sendCmd('PutMasterVolumeBtn%2F%3E' );
	}

	function volume_down(){
		return $this->sendCmd('PutMasterVolumeBtn%2F%3C' );
	}
	
	function power_off(){
		return $this->sendCmd('PutZone_OnOff%2FOFF' );
	}
	
	function power_on(){
		return $this->sendCmd('PutZone_OnOff%2FON' );
	}
	
	function mute_off(){
		return $this->sendCmd('PutVolumeMute%2Foff' );
	}
	
	function mute_on(){
		return $this->sendCmd('PutVolumeMute%2Fon' );
	}
	#/goform/formMainZone_MainZoneXml.xml
}



?>