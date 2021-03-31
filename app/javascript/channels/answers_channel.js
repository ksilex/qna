import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
  consumer.subscriptions.create({channel: "AnswersChannel", question_id: $(".question").data("questionId")}, {
    received(data) {
      if (gon.current_user == $(data).filter('.answer').data("userId")) return
      $('.answers').append(data)
    }
  })
})
