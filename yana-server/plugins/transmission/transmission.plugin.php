<?php

require_once('TransmissionRPC.class.php');


/*
@name transmission
@author S.Guernion <email@gmail.com>

@link https://github.com/sguernion/myPI/tree/master/yana-server/plugins/transmission
@licence CC by nc sa
@version 1.1.0
@description consultation des telechargements dans transmission
*/



function transmission_vocal_command(&$response,$actionUrl){
	global $conf;
}


function transmission_action(){
	global $_,$conf,$myUser;
	
}

function transmission_plugin_preference_menu(){
	global $_;
	echo '<li '.(@$_['block']=='transmission'?'class="active"':'').'><a  href="setting.php?section=preference&block=transmission"><i class="fa fa-angle-right"></i> Serveur Transmission</a></li>';
}


function transmission_plugin_preference_page(){
	global $myUser,$_,$conf;
	if((isset($_['section']) && $_['section']=='preference' && @$_['block']=='domoticz' )  ){
		if($myUser!=false){
	
	?>

		<div class="span9 userBloc">
			<form class="form-inline" action="action.php?action=transmission_plugin_setting" method="POST">
			<legend>Informations sur le serveur Transmission</legend>
			
			    <label>Ip du serveur</label><br/>
			    <input type="text" class="input-xlarge" name="ip" value="<?php echo $conf->get('plugin_transmission_ip');?>" placeholder="localhost">	
			    <br/><br/><label>Port du serveur</label><br/>
			    <input type="text" class="input-large" name="port" value="<?php echo $conf->get('plugin_transmission_port');?>" placeholder="9091">					
			    <br/><br/><label>Nom de l'utilisateur</label><br/>
			    <input type="text" class="input-large" name="user" value="<?php echo $conf->get('plugin_transmission_user');?>" placeholder="toto">					
			    <br/><br/><label>Mot de passe</label><br/>
			    <input type="password" class="input-large" name="pswd" value="<?php echo $conf->get('plugin_transmission_pswd');?>" placeholder="********">					
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

function transmission_plugin_menu(){
	global $_,$conf;
	
	
}

function transmission_widget_plugin_menu(&$widgets){
	
}

function transmission_plugin_page(){
	global $myUser,$_,$conf;
	

}


Plugin::addHook("setting_menu", "transmission_plugin_menu");  
Plugin::addHook("setting_bloc", "transmission_plugin_page"); 
Plugin::addHook("preference_menu", "transmission_plugin_preference_menu"); 
Plugin::addHook("preference_content", "transmission_plugin_preference_page"); 
Plugin::addHook("widgets", "transmission_widget_plugin_menu");

Plugin::addHook("action_post_case", "transmission_action");    
Plugin::addHook("vocal_command", "transmission_vocal_command");
?>
