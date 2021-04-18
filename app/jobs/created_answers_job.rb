class CreatedAnswersJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.find_each(batch_size: 500) do |user|
      NewAnswerMailer.send_answer(user, answer).deliver_later unless user.author?(answer)
    end
  end
end
