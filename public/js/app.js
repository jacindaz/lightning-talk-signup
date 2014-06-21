var order = 1;
var lightningTalks = [
  { name: "Jacinda", topic: "XML"},
  { name: "Yvan", topic: "testing"}
];

/*doesn't work, for some reason*/
function alertSubmitTalk(){
  alert("Sweet! Thanks " + userName + " for signing up!");
}


$( "#talk-description-toggle" ).toggle(function() {
  var showDescription = document.getElementById('talk-description-toggle');
  showDescription.style.display = "block";
})


function persistTalk(){
  var userName = document.sign_up.input_name.value;
  var userTopic = document.sign_up.talk_topic.value;

  document.getElementById("talk-list").innerHTML = (userName + ": " + userTopic);
}

$( "#sign-up" ).submit(function( event ) {
  //add hash with talk info to array
  // var talkDeets = { name: userName, topic: userTopic };
  // lightningTalks.push(talkDeets);

  alert( "Sweet! Thanks for signing up!" );
  event.preventDefault();
});


