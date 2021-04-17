class DailyDigestMailer < ApplicationMailer
  def send_digest(user)
    @questions = Question.where(created_at: Time.current.all_day)
    mail to: user.email
  end
end
