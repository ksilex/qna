class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sleep(3)
  end
end
