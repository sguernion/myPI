<?php


/**
*
*
*
**/
class DomoticzPlugin{

	private $section = "domoticz";
	private $actionUrl = 'action.php';
	protected $conf;
	protected $phrases;
	protected $domoticzApi;
	
	function __construct($conf,$phrases){
		$this->conf = $conf;
		$this->phrases = $phrases;
		$this->domoticzApi = new DomoticzApi($conf);
	}
	
	function actions($_,$myUser){
		if($myUser==false) { 	header('location:index.php?connexion=ko'); }
		switch($_['action']){
				case 'domoticz_plugin_setting':
					$this->action_plugin_setting($_);
				break;
				case 'domoticz_widget_setting':
					$this->domoticz_widget_setting($_);
				break;
				case 'domoticz_add':
					$this->action_add($_);
				break;
				case 'domoticz_delete':
					$this->action_delete($_);
				break;
				case 'domoticz_edit':
					$this->action_edit($_);
				break;
				case 'domoticz_action_switch':
					$this->action_device_switch($_);
				break;
				case 'domoticz_action_scene':
					$this->action_device_switch($_);
				break;
				case 'domoticz_enable':
					$this->action_enable($_);
				break;
				case 'domoticz_action_mesure':
				case 'domoticz_action_utility':
				case 'domoticz_action_variable':
					$this->action_device_mesure($_);
				break;
				case 'domoticz_widget_edit':
					$this->action_widget_edit($_);
				break;
				case 'domoticz_widget_delete':
					$this->action_widget_delete($_);
				break;
				case 'domoticz_widget_load':
					$this->action_widget_load($_);
				break;
		}
	}
	
	/**
	* Domoticz Préférence Methodes
	*
	**/

	
	function action_plugin_setting($_){
			if(isset($_['ip'])){
				$this->conf->put('ip',$_['ip'],'domoticz');
			}
			if(isset($_['port'])){
				$this->conf->put('port',$_['port'],'domoticz');
			}
			if(isset($_['user'])){
				$this->conf->put('user',$_['user'],'domoticz');
			}
			if(isset($_['pswd'])){
				$this->conf->put('pswd',$_['pswd'],'domoticz');
			}
			if(isset($_['devices'])){
				$this->conf->put('widgets_devices',$_['devices']);
			}
			header('location:setting.php?section=preference&block='.$this->section);
	}
	
	
	/**
	* Domoticz Pages Methodes
	*
	**/
	
	function action_add($_){
		$idx=$_['idx'];
		//TODO search by idx
		$devices = $this->domoticzApi->getDevices();
		if (is_array($devices)){
			foreach($devices as $row2){
				if($idx == $row2['idx']){
					$domoticz = new DomoticzCmd();
					$domoticz->setIdx($row2['idx']);
					$domoticz->setType($row2['Type']);
					$domoticz->setDevice($row2['Name']);
					$domoticz->setCategorie($row2['categorie']);
					if($row2['Type'] == 'Scene')
					{
						$domoticz->setCmdOn(', mode '.$row2['Name']);
					}else if($row2['categorie'] == 'mesure'){		
						$domoticz->setCmdOn(',  '.$row2['Name']);
					}else if($row2['categorie'] == 'variable'){	
						$domoticz->setCmdOn(',  valeur '.$row2['Name']);
					}else if($row2['categorie'] == 'utility'){	
						$domoticz->setCmdOn(',  valeur '.$row2['Name']);
					}else {
						$domoticz->setCmdOn(', allume '.$row2['Name']);
						$domoticz->setCmdOff(', eteint '.$row2['Name']);
					}
					
					$domoticz->setConfidence(0.88);
					$domoticz->setVocal(true);
					$domoticz->save();
				
				
					header('location:setting.php?section='.$this->section.'&block=new&save=ok');
				}
			}
		}
	}
	
	function action_edit($_){
		$domoticz = new DomoticzCmd();
		$domoticz = $domoticz->load(array('idx'=>$_['idx']));
		
		$domoticz->setCmdOn($_['cmdOn']);
		$domoticz->setCmdOff($_['cmdOff']);
		$domoticz->setConfidence($_['confidence']);
		$domoticz->setVocal(true);
		$domoticz->save();
		header('location:setting.php?section='.$this->section.'&block=cmd');
	}
	
	function action_delete($_){
		$domoticz = new DomoticzCmd();
		$domoticz->delete(array('idx'=>$_['idx']));
		header('location:setting.php?section='.$this->section.'&block=cmd');
	}
	
	function action_device_switch($_){
		$type="switchlight";
		if($_['action'] == 'domoticz_action_scene'){ 
			$type="switchscene";
		}
		$this->domoticzApi->setState($type,$_['idx'],$_['state'] );
		$affirmation = str_replace('{NAME}',$_['name'],$this->phrases['switchlight'][$_['state']]);
		$response = array('responses'=>array(
                          array('type'=>'talk','sentence'=>$affirmation)
                    ));
        $json = json_encode($response);
        echo ($json=='[]'?'{}':$json); 
		exit;
	}
	
	function action_enable($_){
		$domoticz = new DomoticzCmd();
		$domoticz = $domoticz->load(array('idx'=>$_['idx']));
					
		if ($domoticz->getVocal() ==1) 
		{ 
			$domoticz->setVocal(0);
		}
		elseif ($domoticz->getVocal() ==0)
		{ 
			$domoticz->setVocal(1);
		}
		$domoticz->save();
		header('location:setting.php?section='.$this->section.'&block=cmd&save=ok');
	}
	
	
	function action_device_mesure($_){
		$type="temperature";
		$field='Temp';
		//TODO gestion des mesures % ...
		if($_['action'] == 'domoticz_action_variable'){ 
			$type="variable";
			$field='Value';
			$infos = $this->domoticzApi->getUserVariable($_['idx']);	
		}elseif($_['action'] == 'domoticz_action_utility'){ 
			$type="variable";
			$field='Data';
			$infos = $this->domoticzApi->getInfo($_['idx']);	
		}else{
			$infos = $this->domoticzApi->getInfo($_['idx']);
		}
		$affirmation = str_replace('{VALUE}',$infos[$field],$this->phrases[$type]);
		$response = array('responses'=>array(
                          array('type'=>'talk','sentence'=>$affirmation)
                    ));
        $json = json_encode($response);
        echo ($json=='[]'?'{}':$json); 
		exit;
	}
	
	/**
	* Widgets methodes
	*
	**/
	
	function domoticz_widget_setting($_){
		if(isset($_['devices'])){
			$this->conf->put('widgets_devices',$_['devices'],'domoticz');
		}
		header('location:index.php');
	}
	
	function action_widget_edit($_){
		header('Content-type: application/json');
			$response = array();
			switch($_['bloc']){
				case 'devices':		
				
				echo '<form class="form-inline" action="action.php?action=domoticz_widget_setting" method="POST">
											<label>Widget Devices (id1,id2..)</label><br/>
											<input type="text" class="input-xlarge" name="devices" value="'.$this->conf->get('widgets_devices','domoticz').'" >						
											<br/><button type="submit" class="btn">Sauvegarder</button></form>';
											exit(0);
				break;
			}
	}
	function action_widget_delete($_){}

	function action_widget_load($_){
		header('Content-type: application/json');
			$response = array();
			switch($_['bloc']){
				case 'sunrise':		
					$response['title'] = 'Domoticz Sunrise';
					$sunrise = $this->domoticzApi->getSunRise();
					$response['content'] = '<div style="width: 100%"><p>Aube '.$sunrise['Sunrise'].'</p><p>Crepuscule '.$sunrise['Sunset'].'</p></div>';
				break;
				case 'devices':
						
					$response['title'] = 'Domoticz Devices';
					
					$response['content'] = '<div style="width: 100%">';
					$ids = $this->conf->get('widgets_devices','domoticz');
					$devices = explode (',',$ids);
					if($ids != '' ){
						foreach($devices as $device){
							$infos = $this->domoticzApi->getInfo($device);	
							$path=$this->domoticzApi->getUrl().'/images/';
							if($infos['TypeImg'] == 'lightbulb' ){
								$response['content'] .= '<img value="'.($infos['Status']=='On'?'Off':'On').'" onclick="change_switch_state('.$infos['idx'].',this,\''.$path.$infos['Image'].'48_On.png\',\''.$path.$infos['Image'].'48_Off.png\')" src="'.$path.$infos['Image'].'48_'.$infos['Status'].'.png" title="'.$infos['Name'].'" />';
							}else if($infos['TypeImg'] == 'push'){
								$response['content'] .= '<img value="'.($infos['Status']=='On'?'Off':'On').'" onclick="change_switch_state('.$infos['idx'].',this,\''.$path.$infos['TypeImg'].'on48.png\',\''.$path.$infos['TypeImg'].'off48.png\')" src="'.$path.$infos['TypeImg'].'off48.png" title="'.$infos['Name'].'" />';
							}else if($infos['TypeImg'] == 'door'){
								$response['content'] .= '<img src="'.$path.$infos['TypeImg'].'48'.($infos['Status']=='Open'?'open':'').'.png" title="'.$infos['Name'].'" />';
							}else if($infos['TypeImg'] == 'temperature'){
								$response['content'] .= '<img src="'.$path.'temp48.png" title="'.$infos['Name'].' '.$infos['Data'].'" />';
							} else {
								$response['content'] .= '<img src="'.$path.$infos['TypeImg'].'48.png" title="'.$infos['Name'].' '.$infos['Data'].'" />';
							}
						}
					}else{
						$response['content'] .= 'Aucun Devices, Configurer le widget';
					}
					$response['content'] .= '</div>';
				break;
			}
		echo json_encode($response);
		exit(0);
	}
}
?>