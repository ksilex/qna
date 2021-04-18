class Services::DailyDigest
  def call
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.send_digest(user, questions).deliver_later
    end
  end
  
  private

  def questions
    @questions ||= Question.where(created_at: Time.current.all_day)
  end
end