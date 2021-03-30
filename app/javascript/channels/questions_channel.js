import consumer from "./consumer"
consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    console.log("Connected to the question");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (gon.current_user == $(data).filter('.question').data("userId")) return
    $('.questions').prepend(data);
    // Called when there's incoming data on the websocket for this channel
  }
})
