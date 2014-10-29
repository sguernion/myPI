<?php


/*
@name marantz
@author S.Guernion <email@gmaim.com>
@link https://github.com/sguernion/myPI/tree/master/yana-server/plugins/marantz
@licence CC by nc sa
@version 0.1
@description Permet la commande vocale d'un amplificateur Marantz (testé avec le modèle NR1604 )
*/
require_once('MarantzPlugin.class.php');
require_once('MarantzCmd.class.php');




function marantz_vocal_command(&$response,$actionUrl){
	global $_,$conf;
	$marantzPlugins = new MarantzPlugin($conf);
	$commands = $marantzPlugins->predefined_commands($actionUrl);
	
	foreach($commands as $command){
		$response['commands'][] = array(
					'command'=>$conf->get('VOCAL_ENTITY_NAME').$command['command'],
					'url'=> $command['url'],'confidence'=>$command['confidence']);	
	}		
}

function marantz_action(){
	global $_,$conf,$myUser;
	$marantzPlugins = new MarantzPlugin($conf);
	$marantzPlugins->actions($_,$myUser);
}

function marantz_plugin_menu(){
	echo '<li '.((isset($_['section']) && $_['section']=='marantz') ?'class="active"':'').'><a href="setting.php?section=marantz">> Marantz</a></li>';
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
						$maranzManager = new MarantzCmd();
						$marantzCmds = $maranzManager->populate();
				
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
						
					</thead>
					<?php 	
							
							if (is_array($marantzCmds)){
							foreach($marantzCmds as $row){
									?>
									<tr>
										<!--td><?php //echo $row->getType(); 
										?></td -->
										<td><?php echo $row->getName(); ?></td>
										<td><?php echo $conf->get('VOCAL_ENTITY_NAME').$row->getCmd();?></td>
										<td><?php echo $row->getParametre();?></td>
										<td><?php echo $row->getConfidence(); ?></td>
										<td><a class="btn" href="action.php?action=marantz_enable&id=<?php echo $row->getId(); ?>" >
										<?php 
										if ($row->getVocal()) 
											{ echo '<i class="fa fa-microphone fa-lg" style="color:#84C400"  title="D&eacute;sactive l\’&eacute;coute de cette commande"></i>';} 
										else
											{ echo '<i class="fa fa-microphone-slash fa-lg" style="color:#C1004F" title="Active l\’&eacute;coute de cette commande"></i>';}
										?>
										</a>
										<a class="btn" href="setting.php?section=marantz&amp;block=edit&idx=<?php echo $row->getIdx(); ?>"><i class="fa fa-pencil-square-o fa-lg"></i></a>
										<a class="btn" href="action.php?action=marantz_delete&id=<?php echo $row->getId(); ?>"><i class="fa fa-trash-o fa-lg"  style="color:#C1004F"></i></a></td>
									</tr>
									
									<?php
							}
							} ?>
					
					
					</table>
					
					<?php 	
				}
		}
		
		?>
		<?php 
		 if((isset($_['section']) && $_['section']=='marantz' && (@$_['block']=='new'  || @$_['block']==''))  ){
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
					<?php
					$marantzPlugins = new MarantzPlugin($conf);
					$commands = $marantzPlugins->predefined_commands($actionUrl,$conf->get('VOCAL_ENTITY_NAME'));
					
					foreach($commands as $command){
					?>
							<tr>
							<td><?php echo $command['name'];?></td>
							<td><?php echo $command['command'];?></td>
							<td></td>
							<td><?php echo $command['confidence'];?></td>
							<td><a class="btn" href="action.php?action=marantz_add&id=<?php echo $row2['id']; ?>" title="Active ou désactive l’écoute de cette commande">
										<i class="fa fa-plus fa-lg"></i>
										</a></td>
						</tr>
					
					
					<?php }	 ?>
						
					</thead></table>
					
					<?php 	
				}
		}
		
			 if((isset($_['section']) && $_['section']=='marantz' && @$_['block']=='edit' )  ){
				if($myUser!=false && isset($_['id'])){
				
					if(isset($_['id'])){
						$marantz = new MarantzCmd();
						$marantz = $marantz->load(array('id'=>$_['id']));
					}else{
						$marantz = new MarantzCmd();
					}
					?>
					<div class="span9 userBloc">
						<form class="form-inline" action="action.php?action=marantz_edit" method="POST">
						<legend>Modification de la Commande Vocale</legend>
							<input type="hidden"  name="id" value="<?php echo $marantz->getId();?>" >
							<label>Nom : </label><?php echo $marantz->getName();?>	
							<br/><br/><label>Commande  : </label><br/>
							<?php echo $conf->get('VOCAL_ENTITY_NAME') ?><input type="text" class="input-large" name="cmd" value="<?php echo $marantz->getCmd();?>" >					
							<br/><br/><label>Parametre : </label><br/>
							<input type="text" class="input-large" name="parametre" value="<?php echo $marantz->getParametre();?>" >					
							<br/><br/><label>Confidence :</label><br/>
							<input type="text" class="input-large" name="confidence" value="<?php echo $marantz->getConfidence();?>" >						
							<br/><br/><button type="submit" class="btn">Sauvegarder</button>
						</form>
					</div>
					<?php
				}
		  }
		
		?>
		</div><?
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