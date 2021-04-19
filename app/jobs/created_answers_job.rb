class CreatedAnswersJob < ApplicationJob
  queue_as :default

  def perform(answer)
    CreatedAnswersService.new.call(answer)
  end
end
