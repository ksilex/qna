class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.send_digest(user).deliver_later
    end
  end
end
