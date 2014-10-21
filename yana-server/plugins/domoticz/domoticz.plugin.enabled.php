<?php

require_once('DomoticzCmd.class.php');
require_once('DomoticzApi.class.php');

/*
@name domoticz
@author M.OU <nospam@free.fr>
@author S.Guernion
@link https://github.com/sguernion/myPI/tree/master/yana-server/plugins/domoticz
@licence 
@version 1.1.0
@description Permet la commande vocale des interrupteurs domoticz
*/



function domoticz_vocal_command(&$response,$actionUrl){
	global $conf;
	$domoticz = new DomoticzCmd();
	$domoticzCmd = $domoticz->loadAll(array('vocal'=>true));

	if (is_array($domoticzCmd)){
		foreach($domoticzCmd as $row){
			$response['commands'][] = array(
				'command'=>$conf->get('VOCAL_ENTITY_NAME').$row->getCmdOn(),
				'url'=>$actionUrl.'?action=domoticz_action_'.$row->getCategorie().'&state=On'.'&idx='.$row->getIdx(),'confidence'=>$row->getConfidence(),
				'categorie'=>'Domoticz'
				);	
			if($row->getCmdOff() != null){
				$response['commands'][] = array(
					'command'=>$conf->get('VOCAL_ENTITY_NAME').$row->getCmdOff(),
					'url'=>$actionUrl.'?action=domoticz_action_'.$row->getCategorie().'&state=Off'.'&idx='.$row->getIdx(),'confidence'=>$row->getConfidence(),
					'categorie'=>'Domoticz'
					);		
			}
		}
	}
}


function domoticz_action(){
	global $_,$conf,$myUser;

	if($_['action'] == 'domoticz_plugin_setting'){
			$conf->put('plugin_domoticz_ip',$_['ip']);
			$conf->put('plugin_domoticz_port',$_['port']);
			$conf->put('plugin_domoticz_user',$_['user']);
			$conf->put('plugin_domoticz_pswd',$_['pswd']);
			header('location:setting.php?section=preference&block=domoticz');
	}
	$domoticzApi = new DomoticzApi($conf);
	if($_['action'] == 'domoticz_add'){
		global $_;
		$idx=$_['idx'];
		//TODO search by idx
		$devices = $domoticzApi->getDevices();
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
					}else {
						$domoticz->setCmdOn(', allume '.$row2['Name']);
						$domoticz->setCmdOff(', eteint '.$row2['Name']);
					}
					
					$domoticz->setConfidence(0.88);
					$domoticz->setVocal(true);
					$domoticz->save();
				
				
					header('location:setting.php?section=domoticz&block=new&save=ok');
				}
			}
		}
	}
	
	if($_['action'] == 'domoticz_delete'){
		global $_;
		$domoticz = new DomoticzCmd();
		$domoticz->delete(array('idx'=>$_['idx']));
		header('location:setting.php?section=domoticz&block=cmd');
	}
	
	if($_['action'] == 'domoticz_enable'){
		global $_;
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
		header('location:setting.php?section=domoticz&block=cmd&save=ok');
	}
	
	if($_['action'] == 'domoticz_action_switch' || $_['action'] == 'domoticz_action_scene'){
		$infos = $domoticzApi->getInfo($_['idx']);
		$domoticzApi->setState('switchlight',$_['idx'],$_['state'] );
		
		if($infos['Type'] == 'Scene'){ 
			$affirmation = 'mode '.$infos['Name'].' actif';
		}else{
			if($_['state'] == 'Off'){ $affirmation = 'je viens d\'eteindre '.$infos['Name'];}
			if($_['state'] == 'On'){ $affirmation = 'je viens d\'allumer '.$infos['Name'];}
		}
		$response = array('responses'=>array(
                          array('type'=>'talk','sentence'=>$affirmation)
                    ));
        $json = json_encode($response);
        echo ($json=='[]'?'{}':$json); 
		exit;
	}
	
	if($_['action'] == 'domoticz_action_mesure'){
		$infos = $domoticzApi->getInfo($_['idx']);		
		$affirmation = 'il fait '.$row2['Temp'];
		$response = array('responses'=>array(
                          array('type'=>'talk','sentence'=>$affirmation)
                    ));
        $json = json_encode($response);
        echo ($json=='[]'?'{}':$json); 
		exit;
	}
	
	if($_['action'] == 'domoticz_action_variable'){
		$infos = $domoticzApi->getUserVariable($_['idx']);
		
		$affirmation = 'la valeur est '.$row2['Value'];
		$response = array('responses'=>array(
                          array('type'=>'talk','sentence'=>$affirmation)
                    ));
        $json = json_encode($response);
        echo ($json=='[]'?'{}':$json); 
		exit;
	}
}

function domoticz_plugin_preference_menu(){
	global $_;
	echo '<li '.(@$_['block']=='domoticz'?'class="active"':'').'><a  href="setting.php?section=preference&block=domoticz"><i class="fa fa-angle-right"></i> Serveur Domoticz</a></li>';
}


function domoticz_plugin_preference_page(){
	global $myUser,$_,$conf;
	if((isset($_['section']) && $_['section']=='preference' && @$_['block']=='domoticz' )  ){
		if($myUser!=false){
	
	?>

		<div class="span9 userBloc">
			<form class="form-inline" action="action.php?action=domoticz_plugin_setting" method="POST">
			<legend>Informations sur le serveur Domoticz</legend>
			
			    <label>Ip du serveur Domoticz</label><br/>
			    <input type="text" class="input-xlarge" name="ip" value="<?php echo $conf->get('plugin_domoticz_ip');?>" placeholder="localhost">	
			    <br/><br/><label>Port du serveur Domoticz</label><br/>
			    <input type="text" class="input-large" name="port" value="<?php echo $conf->get('plugin_domoticz_port');?>" placeholder="8080">					
			    <br/><br/><label>Nom de l'utilisateur</label><br/>
			    <input type="text" class="input-large" name="user" value="<?php echo $conf->get('plugin_domoticz_user');?>" placeholder="toto">					
			    <br/><br/><label>Mot de passe</label><br/>
			    <input type="password" class="input-large" name="pswd" value="<?php echo $conf->get('plugin_domoticz_pswd');?>" placeholder="********">					
			    <br/><br/><button type="submit" class="btn">Sauvegarder</button>
	    </form>
		<?php 
			if(!function_exists('curl_version')){
				echo '<strong>Important: </strong>Pour profiter de ce plugin il vous faut installer CURL  <code>sudo apt-get install php5-curl</code><BR><BR>';
				}
			?>
		</div>

<?php }else{ ?>

		<div id="main" class="wrapper clearfix">
			<article>
					<h3>Vous devez être connecté</h3>
			</article>
		</div>
<?php

		}
	}
}

function domoticz_plugin_menu(){
	global $_;
	echo '<li '.((isset($_['section']) && $_['section']=='domoticz') || !isset($_['section']) ?'class="active"':'').'><a href="setting.php?section=domoticz"><i class="fa fa-angle-right"></i> Domoticz</a></li>';
}

function domoticz_plugin_page(){
	global $myUser,$_,$conf;
	if((isset($_['section']) && $_['section']=='domoticz') || !isset($_['section'])  ){
		if($myUser!=false){
		
		
			
	?>

		<div class="span9 userBloc">
		<h1>Domoticz</h1>
		<p>Votre système domotique	</p>
		<ul class="nav nav-tabs">
			<li <?php echo (!isset($_['block']) || $_['block']=='cmd'?'class="active"':'')?> > <a href="setting.php?section=domoticz&amp;block=cmd"><i class="fa fa-angle-right"></i> Commandes Vocales</a></li>
			<li <?php echo (isset($_['block']) && $_['block']=='new'?'class="active"':'')?> > <a href="setting.php?section=domoticz&amp;block=new"><i class="fa fa-angle-right"></i> Nouvelles Commandes</a></li>

		</ul>
		 <?php 
		 if((isset($_['section']) && $_['section']=='domoticz' && (@$_['block']=='cmd'  || @$_['block']==''))  ){
				if($myUser!=false){
		 
				$DomoticzManager = new DomoticzCmd();
				$DomoticzCmds = $DomoticzManager->populate();
				
				?>
		
			<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<!--th>Type</th -->
							<th>device</th>
							
							<th>Commande vocale On</th>
							<th>Commande vocale Off</th>
							<th>Confidence</th>
							<th>Actions</th>
						</tr>
						
					</thead>
					
					<?php 	
							
							if (is_array($DomoticzCmds)){
							foreach($DomoticzCmds as $row){
									?>
									<tr>
										<!--td><? //echo $row->getType(); 
										?></td -->
										<td><? echo $row->getDevice(); ?></td>
										<td><? echo $conf->get('VOCAL_ENTITY_NAME').$row->getCmdOn();?></td>
										<td><? echo $conf->get('VOCAL_ENTITY_NAME').$row->getCmdOff();?></td>
										<td><? echo $row->getConfidence(); ?></td>
										<td><a class="btn" href="action.php?action=domoticz_enable&idx=<?php echo $row->getIdx(); ?>" title="Active ou désactive l’écoute de cette commande">
										<?php 
										if ($row->getVocal()) 
											{ echo '<i class="fa fa-microphone fa-lg" style="color:#84C400"></i>';} 
										else
											{ echo '<i class="fa fa-microphone-slash fa-lg" style="color:#C1004F"></i>';}
										?>
										</a><a class="btn" href="action.php?action=domoticz_delete&idx=<?php echo $row->getIdx(); ?>">x</a></td>
									</tr>
									
									<?php
							}
							} ?>
					
			</table>
		 <?php
		 }}
		 
		 
		 if((isset($_['section']) && $_['section']=='domoticz' && @$_['block']=='new' )  ){
				if($myUser!=false){
					?>
		
			<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th>Type</th>
							<th>device</th>
							
							<th>Commande vocale On</th>
							<th>Commande vocale Off</th>
							<th>Confidence</th>
							<th>Actions</th>
						</tr>
						
					</thead>
					
					<?php 	
							$domoticzApi = new DomoticzApi($conf);
							$devices = $domoticzApi->getDevices();
							
							
					
							if (is_array($devices)){
							foreach($devices as $row2){
							
								$domoticz = new DomoticzCmd();
								$domoticzCmd = $domoticz->loadAll(array('idx'=>$row2['idx']));
								if($domoticzCmd == null){
									?>
									<tr>
										<td><? echo $row2['Type']; ?></td>
										<td><? echo $row2['Name']; ?></td>
										<td><? 
										if($row2['Type'] == 'Scene')
										{
											echo $conf->get('VOCAL_ENTITY_NAME').', mode '.$row2['Name'];
										}else if($row2['categorie'] == 'mesure'){	
											echo $conf->get('VOCAL_ENTITY_NAME').',  '.$row2['Name'];
										}else if($row2['categorie'] == 'variable'){	
											echo $conf->get('VOCAL_ENTITY_NAME').',  valeur '.$row2['Name'];
										}else {
											echo $conf->get('VOCAL_ENTITY_NAME').', allume '.$row2['Name'];
										}
										
										?></td>
										<td><? 
										if($row2['Type'] != 'Scene' && $row2['categorie'] != 'mesure' && $row2['categorie'] != 'variable')
										{
											echo $conf->get('VOCAL_ENTITY_NAME').', eteint '.$row2['Name'];
										}
										?></td>
										<td>0.88</td>
										<td><a class="btn" href="action.php?action=domoticz_add&idx=<?php echo $row2['idx']; ?>" title="Active ou désactive l’écoute de cette commande">
										Add
										</a></td>
									</tr>
									
									<?php
								}
							}
							} ?>
					
			</table>
		<br/>
		<?php }} ?>
	  
		</div>

<?php }else{ ?>

		<div id="main" class="wrapper clearfix">
			<article>
					<h3>Vous devez être connecté</h3>
			</article>
		</div>
<?php

		}
	}
}


Plugin::addHook("setting_menu", "domoticz_plugin_menu");  
Plugin::addHook("setting_bloc", "domoticz_plugin_page"); 
Plugin::addHook("preference_menu", "domoticz_plugin_preference_menu"); 
Plugin::addHook("preference_content", "domoticz_plugin_preference_page"); 
    
Plugin::addHook("action_post_case", "domoticz_action");    
Plugin::addHook("vocal_command", "domoticz_vocal_command");
?>
