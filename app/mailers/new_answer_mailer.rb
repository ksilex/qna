class NewAnswerMailer < ApplicationMailer
  def send_answer(user, answer)
    @answer = answer
    mail to: user.email
  end
end
