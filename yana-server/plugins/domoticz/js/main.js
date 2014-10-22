$(document).ready(function(){

});

function change_switch_state(state,idx,element){
	bState = $(element).text()=='on'?0:1;
	$.ajax({
		  url: "action.php",
		  type: "POST",
		  data: {action:'domoticz_action_switch',state:state,idx:idx},
		  success:function(response){
		  	if(state){
		  		//TODO change image
				
		  	}else{
		  		//TODO change image
				
		  	}

		  }
		});
}