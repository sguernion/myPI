var configuration = require('./configuration.js');
var mqtt = require('mqtt');
var url = require('url');
var http = require('http');
var request = require('request');

/*
this script will act as a device-driver for Domoticz. 
Events in Domoticz are published to topics beneath /events/domoticz/# 
Actions that Domoticz should perform can be triggered by publishing to /actions/domoticz/#
See also topic http://www.domoticz.com/forum/viewtopic.php?f=5&t=838
*/
client = mqtt.createClient(configuration.mqtt_port, configuration.mqtt_ip);


/* here we subscribe to topic /actions/domoticz in mqtt. Parseble messages which are published here will be sent to Domoticz
open a new SSH window and type 'mosquitto_sub -v -t /#' to test
Example 1 (JSON, SensorType):
test: 			mosquitto_pub -t /actions/domoticz/xyz -m '{"SensorType":"Temperature","svalue":"21.1"}'
intended use:	if you want new devices to be created in the unused tab automatically. 
explanation: 	using a lookup table, the SensorType will be mapped to certain combination of dtype and dsubtype. I'm trying to use as much as possible the names and types as used for virtual sensors in the domoticz GUI.
Example 2 (JSON, idx-value):
test: 			mosquitto_pub -t /actions/domoticz/xyz -m '{"idx":247,"svalue":"21.1;70%"}'
intended use: 	if you (or something else) already created the sensor in Domoticz it can be referred by it's idx-number
Example 2 (JSON, did/dunit/dtype/dsubtype):
test:			mosquitto_pub -t /actions/domoticz/xyz -m '{"dunit":1,"dtype":80,"dsubtype":9,"svalue":"21.1"}'
intended use: 	if you want to use your own dtype/dsubtype instead of the predefined ones in SensorType or dunit other than 1
(for dtype and dsubtype please refer to http://sourceforge.net/p/domoticz/code/HEAD/tree/domoticz/main/RFXtrx.h
e.g. 80,9 = temperature, 82,10 = temperature+humidity, 32, 1 = shuttercontact)
Example 4 (Normal, idx-value):
test:			mosquitto_pub -t /actions/domoticz/247 -m 21.1
intended use: 	if you find JSON a bit complicated
explanation:	last number in topic should be idx-number. Payload is svalue.
*/

client.subscribe('/actions/domoticz/#');
client.on('message', function (topic, message) {
  console.log('Received: '+ topic + ' ' + message);
  var url = 'http://'+configuration.Domoticz_IP+':'+configuration.Domoticz_Port;
  
  var hid = configuration.Domoticz_HID;
  var svalue = 0;
  var nvalue = 0;
  var idx = 0;
  var dunit = 1;  	// default 
  var dtype = 80;   // default = temperature device
  var dsubtype = 9;
      
  try {
    var payload = JSON.parse(message);  
    
	if (payload !=  null) {
	  console.log('JSON Payload');
	  if(payload.hid) {
	    hid = payload.hid;
	  }
	  if(payload.nvalue) {
        nvalue = payload.nvalue;
      }
      if(payload.svalue) {
        svalue = payload.svalue;
      }
	  if(payload.dunit) {
	    dunit = payload.dunit;
	  }
	  if(payload.dsubtype) {
	    dsubtype = payload.dsubtype;
	  }
	  //use idx if found, otherwise use hid/did/dunit/dtype/dsubtype style of interfacing with domoticz.
	  if(payload.idx) {
        idx = payload.idx;
		url = url + "/json.htm?type=command&param=udevice&idx="+idx+
			"&nvalue="+nvalue+"&svalue="+svalue;

      }
	  else {
	    if (payload.SensorType) {
			switch (payload.SensorType.toLowerCase()) {
			case "temperature":
				dtype = 80;
				dsubtype = 1;
				break;
			case "humidity":
				dtype = 81;
				dsubtype = 1;
				break;
			case "temp+hum":
				dtype = 82;
				dsubtype = 1;
				svalue = svalue + ';0';  // don't know why this is needed
				// also for no apparent reason the &did cannot be a random string so it will end up like 0000
				break;
			case "temp+hum+baro":
				dtype = 84;
				dsubtype = 1;
				// unclear what the svalue should look like ???
				break;
			case "rain":
				dtype = 85;
				dsubtype = 3;
				break;
			case "wind":
				dtype = 86;
				dsubtype = 1;
				// 0;N;0;0;0;0 ???
				break;
			case "uv":
				dtype = 87;
				dsubtype = 1;
				// 0.0 UVI
				break;
			case "electricity":
				dtype = 250;
				dsubtype = 1;
				break;
			case "gas":
			    dtype = 251;
				dsubtype = 0;
				break;
			case "shuttercontact":
				dtype = 32;
				dsubtype = 1;
				break;
			case "counter":
				dtype = 113;
				dsubtype = 0;
				break;
			default:
				console.log('Warning: no matching SensorType. Default used');
				break;				
			};
		};
		url = url + "/json.htm?type=command&param=udevice&hid="+hid+"&did="+topic+"&dunit="+dunit+"&dtype="+dtype+"&dsubtype="+dsubtype+
			"&nvalue="+nvalue+"&svalue="+svalue;  
	  };
    }
    else {
		console.log('Normal Payload');
	  
		var parts = topic.split("/");
		idx = parts.pop();
		svalue = message;
		
		url = url + "/json.htm?type=command&param=udevice&idx="+idx+"&nvalue=0&svalue="+svalue;
	};
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