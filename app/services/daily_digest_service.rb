class DailyDigestService
  def call
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.send_digest(user).deliver_later
    end
  end
end
