$(document).ready(function() {
  $('#accordion').accordion().removeClass('highlight');
});



$( "#one-talk" ).toggle(function() {
  document.getElementById("icon-id").className = "glyphicon glyphicon-chevron-right"
}, function() {
  document.getElementById("icon-id").className = "glyphicon glyphicon-chevron-down"
});


$( "#target" ).toggle(function() {
  alert( "First handler for .toggle() called." );
}, function() {
  alert( "Second handler for .toggle() called." );
});

function thanksAlert() {
  var userName = document.sign_up.input_first_name.value;
  alert("Thanks " + userName + " for submitting a lightning talk!");
}
