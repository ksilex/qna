class Services::DailyDigest
  def call
    User.find_each do |user|
      DailyDigestMailer.send_digest(user).deliver_later
    end
  end
  
end