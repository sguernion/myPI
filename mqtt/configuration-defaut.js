

var	domoticz_HID = '3'; 								//Hardware ID of dummy in Domoticz
	domoticz_IP = '127.0.0.1';							//IP address of Domoticz (127.0.0.1 for same machine)
	domoticz_Port = '8080';								//Port of Domoticz
	domoticz_topic_action ='/actions/domoticz/#';
	domoticz_topic_events ='/events/domoticz';

var	yana_IP = '127.0.0.1';								//IP address of  Yana-server
	yana_Port = '80';									//Port of Yana-server
	yana_token =''										//Token of Yana-server
	yana_topic_action ='/actions/yana/#';

var mqtt_port = 1883;
var mqtt_ip ='localhost';


module.exports.domoticz_HID = domoticz_HID;
module.exports.domoticz_IP = domoticz_IP;
module.exports.domoticz_Port = domoticz_Port;
module.exports.domoticz_topic_action = domoticz_topic_action;
module.exports.domoticz_topic_events = domoticz_topic_events;

module.exports.yana_IP = yana_IP;
module.exports.yana_Port = yana_Port;
module.exports.yana_token = yana_token;
module.exports.yana_topic_action = yana_topic_action

module.exports.mqtt_port = mqtt_port;
module.exports.mqtt_ip = mqtt_ip;