

$( '#one-talk-id-la' ).click(function() {
  alert("inside one-talk-id alert")
  toggle(function() {
    document.getElementById("span-icon-id").className = "glyphicon glyphicon-chevron-right"
  }, function() {
    document.getElementById("span-icon-id").className = "glyphicon glyphicon-chevron-down"
  });
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
