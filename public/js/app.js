var order = 1;
var lightningTalks = [
  { name: "Jacinda", topic: "XML"},
  { name: "Yvan", topic: "testing"}
];


function submitTalk(){
  var userName = document.sign_up.input_name.value;
  var userTopic = document.sign_up.talk_topic.value;
  var talkDeets = { name: userName, topic: userTopic };
  lightningTalks.push(talkDeets);
  alert("Sweet! Thanks " + userName + " for signing up!");
}



$( "#sign-up" ).submit(function( event ) {
  //add hash with talk info to array
  // var talkDeets = { name: userName, topic: userTopic };
  // lightningTalks.push(talkDeets);

  alert( "Sweet! Thanks for signing up!" );
  event.preventDefault();
});


