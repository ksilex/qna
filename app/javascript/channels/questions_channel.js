import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
  consumer.subscriptions.create("QuestionsChannel", {
    received(data) {
      if (gon.current_user == $(data).filter('.question').data("userId")) return
      $('.questions').prepend(data)
    }
  })
})
