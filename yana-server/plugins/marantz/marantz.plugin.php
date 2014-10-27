<?php


/*
@name marantz
@author S.Guernion
@link https://github.com/sguernion/myPI/tree/master/yana-server/plugins/marantz
@licence 
@version 0.1
@description Permet la commande vocale d'un amplificateur Marantz
*/
require_once('MarantzPlugin.class.php');


function marantz_vocal_command(&$response,$actionUrl){
	global $_,$conf;
	$response['commands'][] = array(
				'command'=>$conf->get('VOCAL_ENTITY_NAME').' Monte le son',
				'url'=> $actionUrl.'?action=marantz_action_vup','confidence'=>'0.8');	
				
	$response['commands'][] = array(
				'command'=>$conf->get('VOCAL_ENTITY_NAME').' Baisse le son',
				'url'=> $actionUrl.'?action=marantz_action_vdown','confidence'=>'0.8');	

	$response['commands'][] = array(
				'command'=>$conf->get('VOCAL_ENTITY_NAME').' Ampli Off',
				'url'=> $actionUrl.'?action=marantz_action_poff','confidence'=>'0.8');	

	$response['commands'][] = array(
				'command'=>$conf->get('VOCAL_ENTITY_NAME').' Ampli On',
				'url'=> $actionUrl.'?action=marantz_action_pon','confidence'=>'0.8');					
}

function marantz_action(){
	global $_,$conf,$myUser;
	$marantzPlugins = new MarantzPlugin($conf);
	$marantzPlugins->actions($_,$myUser);
}

function marantz_plugin_menu(){
	//echo '<li '.((isset($_['section']) && $_['section']=='marantz') ?'class="active"':'').'><a href="setting.php?section=marantz">> Marantz</a></li>';
}

function marantz_plugin_page(){
	global $_,$conf,$myUser;
		if((isset($_['section']) && $_['section']=='marantz')  ){
		if($myUser!=false){
	?>
	<div class="span9 userBloc">
		<h1>Marantz</h1>
		<p></p>
		<ul class="nav nav-tabs">
			<li <?php echo (!isset($_['block']) || $_['block']=='cmd'?'class="active"':'')?> > <a href="setting.php?section=marantz&amp;block=cmd"><i class="fa fa-angle-right"></i> Commandes Vocales</a></li>
			<li <?php echo (isset($_['block']) && $_['block']=='new'?'class="active"':'')?> > <a href="setting.php?section=marantz&amp;block=new"><i class="fa fa-angle-right"></i> Nouvelles Commandes</a></li>
			<li <?php echo (isset($_['block']) && $_['block']=='edit'?'class="active"':'class="disabled"')?> > <a href="setting.php?section=marantz&amp;block=edit"><i class="fa fa-angle-right"></i> Modification</a></li>
		</ul>
	
	
	<?php 
		 if((isset($_['section']) && $_['section']=='marantz' && (@$_['block']=='cmd'  || @$_['block']==''))  ){
				if($myUser!=false){
						?>
		
					<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th>Name</th>
							<th>Commande vocale</th>
							<th>Paramètres</th>
							<th>Confidence</th>
							<th>Actions</th>
						</tr>
						
					</thead></table>
					
					<?php 	
				}
		}
		
		?></div><?
		}
	}
}

function marantz_plugin_preference_menu(){
	global $_;
	echo '<li '.(@$_['block']=='marantz'?'class="active"':'').'><a  href="setting.php?section=preference&block=marantz"><i class="fa fa-angle-right"></i> Marantz</a></li>';
}

function marantz_plugin_preference_page(){
	global $myUser,$_,$conf;
	if((isset($_['section']) && $_['section']=='preference' && @$_['block']=='marantz' )  ){
		if($myUser!=false){ ?>
			<div class="span9 userBloc">
			<form class="form-inline" action="action.php?action=marantz_plugin_setting" method="POST">
			<legend>Informations de connexion a l'Ampli Marantz</legend>
			
			    <label>Ip de l'amplificateur</label><br/>
			    <input type="text" class="input-xlarge" name="ip" value="<?php echo $conf->get('plugin_marantz_ip');?>" placeholder="192.168.0.11">	
			    <br/><br/><label>Port du e l'amplificateur</label><br/>
			    <input type="text" class="input-large" name="port" value="<?php echo $conf->get('plugin_marantz_port');?>" placeholder="80">					
			    <br/><br/><button type="submit" class="btn">Sauvegarder</button>
	    </form>
		<?php 
			if(!function_exists('curl_version')){
				echo '<strong>Important: </strong>Pour profiter de ce plugin il vous faut installer CURL  <code>sudo apt-get install php5-curl</code><BR><BR>';
				}
			?>
		</div>
		<?php
		}else{ ?>

		<div id="main" class="wrapper clearfix">
			<article>
					<h3>Vous devez être connecté</h3>
			</article>
		</div>
	<?php

		}
	}
}



Plugin::addJs('/js/main.js',true);
Plugin::addHook("setting_menu", "marantz_plugin_menu");  
Plugin::addHook("setting_bloc", "marantz_plugin_page"); 
Plugin::addHook("preference_menu", "marantz_plugin_preference_menu"); 
Plugin::addHook("preference_content", "marantz_plugin_preference_page"); 
#Plugin::addHook("widgets", "marantz_widget_plugin_menu");

Plugin::addHook("action_post_case", "marantz_action");    
Plugin::addHook("vocal_command", "marantz_vocal_command");
?>