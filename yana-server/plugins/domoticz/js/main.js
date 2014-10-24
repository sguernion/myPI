$(document).ready(function(){

});

function change_switch_state(idx,element,imgOn,imgOff){
	state = $(element).attr('value');
	bState = state=='Off'?1:0;
	$.ajax({
		  url: "action.php",
		  type: "POST",
		  data: {action:'domoticz_action_switch',state:state,idx:idx},
		  success:function(response){
		  	if(bState){
				$(element).attr('src', imgOff);
				$(element).attr('value', 'On');
				
		  	}else{
				$(element).attr('src', imgOn);
				$(element).attr('value', 'Off');
		  	}

		  }
		});
}