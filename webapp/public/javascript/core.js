$(document).ready(function(){
  var makeAjaxPost = function(url, fun, data){
	$.ajax({
		type: "POST",
		url: url,
		data: data,
		success: fun,
	});
  };
  $("button.newprocess").click(function(){
  	console.debug('attempting to start a new process');
  	var fun = function(response){
		console.debug(response);
	};
  	makeAjaxPost("/newprocess", fun,null);
  });
  $("button.status").click(function(){
  	console.debug('attempting to check status');
  	var fun = function(response){
  		console.debug(response);
  		console.debug("response: "+JSON.parse(response));
  		var data = JSON.parse(response);
  		$('div.data').html(data.length);

  	};
  	makeAjaxPost("/status", fun, null);
  });
});