<?php

/*
 @nom: Marantz
 @description:  Classe de gestion des commandes marantz
 */

class MarantzCmd extends SQLiteEntity{

	protected $id,$name,$cmd,$parametre,$confidence,$vocal;
	protected $TABLE_NAME = 'plugin_marantz';
	protected $CLASS_NAME = 'MarantzCmd';
	protected $object_fields = 
	array(
		'id'=>'key',
		'name'=>'string',
		'parametre'=>'string',
		'cmd'=>'string',
        'confidence'=>'string',
		'vocal'=>'boolean'
	);

	function __construct(){
		parent::__construct();
	}

	function setId($id){
		$this->id = $id;
	}
	
	function getId(){
		return $this->id;
	}
	
	

	function getName(){
		return $this->name;
	}

	function setName($name){
		$this->name = $name;
	}



	function getCmd(){
		return $this->cmd;
	}

	function setCmd($cmd){
		$this->cmd = $cmd;
	}
	
	function getParametre(){
		return $this->parametre;
	}

	function setParametre($parametre){
		$this->parametre = $parametre;
	}
        
	function getConfidence(){
		return $this->confidence;
	}

	function setConfidence($confidence){
		$this->confidence = $confidence;
	}
	
	function getVocal()
	{
		return $this->vocal;
	}

	function setVocal($vocal)
	{
		$this->vocal = $vocal;
	}

}

?>
