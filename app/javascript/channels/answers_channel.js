import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
consumer.subscriptions.create({channel: "AnswersChannel", question_id: $(".question").data("id")}, {
  connected() {
     console.log($(".question").data("id"));
    console.log("Connected to the question!");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('.answers').prepend(data);
    console.log(data);
    // Called when there's incoming data on the websocket for this channel
  }
});})
