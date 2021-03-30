import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
  consumer.subscriptions.create({channel: "CommentsChannel", question_id: $(".question").data("questionId")}, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (gon.current_user == $(data).filter('.comment').data("userId")) return
      var resource = $(data).filter('.comment').data("resource")
      var resource_id = $(data).filter('.comment').data("parentId")
      $(`.${resource}[data-${resource}-id="${resource_id}"] .${resource}-comments`).prepend(data)
    }
  })
})
