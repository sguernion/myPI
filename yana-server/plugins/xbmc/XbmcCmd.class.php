<?php

/*
 @nom: Xbmc
 @auteur: fafnus (fafnus@yahoo.fr)
 @description:  Classe de gestion des commandes media-center XBMC
 */

class XbmcCmd extends SQLiteEntity{

	protected $id,$name,$description,$json,$confidence,$room;
	protected $TABLE_NAME = 'plugin_xbmc';
	protected $CLASS_NAME = 'XbmcCmd';
	protected $object_fields = 
	array(
		'id'=>'key',
		'name'=>'string',
		'description'=>'string',
		'json'=>'string',
                'confidence'=>'string',
		'room'=>'int'
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

	function getDescription(){
		return $this->description;
	}

	function setDescription($description){
		$this->description = $description;
	}

	function getJson(){
		return urldecode($this->json);
	}

	function setJson($json){
		$this->json = urlencode(htmlspecialchars_decode($json));
	}
        
	function getConfidence(){
		return $this->confidence;
	}

	function setConfidence($confidence){
		$this->confidence = $confidence;
	}
	
	function getRoom(){
		return $this->room;
	}

	function setRoom($room){
		$this->room = $room;
	}

}

?>
