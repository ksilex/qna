import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    console.log("Connected to the room!");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('.questions').prepend(data);
    // Called when there's incoming data on the websocket for this channel
  }
});
})
