import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
consumer.subscriptions.create({channel: "AnswersChannel", question_id: $(".question").data("questionId")}, {
  connected() {
    console.log("Connected to the answer");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (gon.current_user == $(data).filter('.answer').data("userId")) return
    $('.answers').append(data)
    // Called when there's incoming data on the websocket for this channel
  }
});})
