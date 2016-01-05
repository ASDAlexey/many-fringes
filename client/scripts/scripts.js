/*var request;
$('#form').on('click',function(e){
  e.preventDefault();
  request=$.ajax({
    url:"/Users/login",
    method:"POST",
    data:{"name":$('#form').find('input[name="name"]').val(),"password":$('#form').find('input[name="password"]').val()},
    //dataType:"application/json"
  });
  request.done(function(msg){
    $("#log").html(msg);
  });
  request.fail(function(jqXHR,textStatus){
    console.log("Request failed: "+textStatus);
  });
});*/
