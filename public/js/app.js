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


function addTalk(){
  var userName = document.sign_up.input_name.value;
  var userTopic = document.sign_up.talk_topic.value;
  var addTalkListItem = $("<li>");
  addTalkListItem.html(userName + ": " + userTopic);
  $('ul#talk-list').append(addTalkListItem);
}

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


