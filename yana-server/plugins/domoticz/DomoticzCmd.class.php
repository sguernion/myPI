<?php

/*
 @nom: Domoticz
 @description:  Classe de gestion des commandes domoticz
 */

class DomoticzCmd extends SQLiteEntity{

	protected $id,$idx,$type,$categorie,$device,$cmdOn,$cmdOff,$reponsesOff,$reponsesOn,$confidence,$vocal;
	protected $TABLE_NAME = 'plugin_domoticz';
	protected $CLASS_NAME = 'DomoticzCmd';
	protected $object_fields = 
	array(
		'id'=>'key',
		'idx'=>'int',
		'type'=>'string',
		'device'=>'string',
		'cmdOn'=>'string',
		'cmdOff'=>'string',
		'reponsesOn'=>'string',
		'reponsesOff'=>'string',
		'categorie'=>'string',
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
	
	function setIdx($idx){
		$this->idx = $idx;
	}
	
	function getIdx(){
		return $this->idx;
	}

	function getType(){
		return $this->type;
	}

	function setType($type){
		$this->type = $type;
	}

	function getDevice(){
		return $this->device;
	}

	function setDevice($device){
		$this->device = $device;
	}

	function getCmdOn(){
		return $this->cmdOn;
	}

	function setCmdOn($cmdOn){
		$this->cmdOn = $cmdOn;
	}
	
	function getCmdOff(){
		return $this->cmdOff;
	}

	function setCmdOff($cmdOff){
		$this->cmdOff = $cmdOff;
	}
	
	function getReponsesOn(){
		return $this->reponsesOn;
	}

	function setReponsesOn($reponsesOn){
		$this->reponsesOn = $reponsesOn;
	}
	
	function getReponsesOff(){
		return $this->reponsesOff;
	}

	function setReponsesOff($reponsesOff){
		$this->reponsesOff = $reponsesOff;
	}
        
	function getConfidence(){
		return $this->confidence;
	}

	function setConfidence($confidence){
		$this->confidence = $confidence;
	}
	
	function getCategorie(){
		return $this->categorie;
	}

	function setCategorie($categorie){
		$this->categorie = $categorie;
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
