
var cfg = require('./configuration.js');


var mqtt = require('mqtt');
var url = require('url');
var http = require('http');
var request = require('request');

client = mqtt.createClient(cfg.mqtt_port, cfg.mqtt_ip);


client.subscribe('/actions/yana/#');
client.on('message', function (topic, message) {
  console.log('Received: '+ topic + ' ' + message);
  var url = 'http://'+cfg.yana_IP+':'+cfg.yana_Port+'/yana-server/action.php';
  

      
  try {
    var payload = JSON.parse(message);  
    var command='';
    var query='';
    var confidence='';

	if (payload !=  null) {
	  console.log('JSON Payload');
	  if(payload.command) {
	    command = payload.command;
	  }
	  if(payload.query) {
        query = payload.query;
      }
      if(payload.confidence) {
        confidence = payload.confidence;
      }
	


	   url = url + "?"+query+'&token='+cfg.yana_token;  
	}    
   
	request(url, function(error, response, body){
	console.log("Sending request");
	console.log(url);
	console.log(error);
	//	console.log(response);
	console.log(body);
  });

  }
  catch(e) {
    console.log("Could not parse payload");
    console.log(e);
  }
});