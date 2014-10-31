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
	if($_['action'] == 'transmission_widget_load'){
	header('Content-type: application/json');
				$rpc = new TransmissionRPC();
				if($conf->get('user','transmission') != ''){
					$rpc->username = $conf->get('user','transmission');
				}
				if($conf->get('pswd','transmission') != ''){
					$rpc->password =$conf->get('pswd','transmission');
				}
				$rpc->url = 'http://'.$conf->get('ip','transmission').':'.$conf->get('port','transmission').'/transmission/rpc';
					$response['title'] = 'Transmission';
					$response['content'] = '<div style="width: 100%">';
					try
					{
					  $rpc->return_as_array = true;
					   $result = $rpc->get(array(),array('name','percentDone','id'));

						 $torrents = $result['arguments']['torrents'];
						 $response['content'] .='<ul>';
						  foreach($torrents as $torrent){
						  
							 $response['content'] .= '<li title="'.$torrent['name'].'"> '.substr ($torrent['name'],0,40).' <span class="label '.($torrent['percentDone']== 1?'label-success':($torrent['percentDone'] > 0.5?'label-info':'label-warning')).'">'.($torrent['percentDone']*100).'%</span></li>';
						  
						  }
						   $response['content'] .='</ul>';
						  
					  
					  $rpc->return_as_array = false;
					  
					  
					} catch (Exception $e) {
					  $response['content'] .='Erreur de connexion';
					}
					
					
					
					$response['content'] .= '</div>';
					echo json_encode($response);
					exit(0);
	}
	
	if($_['action'] == 'transmission_plugin_setting'){
		if(isset($_['ip'])){
				$conf->put('ip',$_['ip'],'transmission');
			}
			if(isset($_['port'])){
				$conf->put('port',$_['port'],'transmission');
			}
			if(isset($_['user'])){
				$conf->put('user',$_['user'],'transmission');
			}
			if(isset($_['pswd'])){
				$conf->put('pswd',$_['pswd'],'transmission');
			}
			header('location:setting.php?section=preference&block=transmission');
	}
	
}

function transmission_plugin_preference_menu(){
	global $_;
	echo '<li '.(@$_['block']=='transmission'?'class="active"':'').'><a  href="setting.php?section=preference&block=transmission"><i class="fa fa-angle-right"></i> Serveur Transmission</a></li>';
}


function transmission_plugin_preference_page(){
	global $myUser,$_,$conf;
	if((isset($_['section']) && $_['section']=='preference' && @$_['block']=='transmission' )  ){
		if($myUser!=false){
	
	?>

		<div class="span9 userBloc">
			<form class="form-inline" action="action.php?action=transmission_plugin_setting" method="POST">
			<legend>Informations sur le serveur Transmission</legend>
			
			    <label>Ip du serveur</label><br/>
			    <input type="text" class="input-xlarge" name="ip" value="<?php echo $conf->get('ip','transmission');?>" placeholder="localhost">	
			    <br/><br/><label>Port du serveur</label><br/>
			    <input type="text" class="input-large" name="port" value="<?php echo $conf->get('port','transmission');?>" placeholder="9091">					
			    <br/><br/><label>Nom de l'utilisateur</label><br/>
			    <input type="text" class="input-large" name="user" value="<?php echo $conf->get('user','transmission');?>" placeholder="toto">					
			    <br/><br/><label>Mot de passe</label><br/>
			    <input type="password" class="input-large" name="pswd" value="<?php echo $conf->get('pswd','transmission');?>" placeholder="********">					
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
	$widgets[] = array(
		    'uid'      => 'transmission_widget_dl',
		    'icon'     => 'fa fa-play-circle-o',
		    'label'    => 'Transmission',
		    'background' => '#50597B', 
		    'color' => '#fffffff',
		    'onLoad'   => 'action.php?action=transmission_widget_load&bloc=dl',
			'onEdit'   => 'action.php?action=transmission_widget_edit&bloc=dl',
			'onDelete'   => 'action.php?action=transmission_widget_delete&bloc=dl'
		);
	
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
