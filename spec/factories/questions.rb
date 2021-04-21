FactoryBot.define do
  factory :question do
    user
    title { "question_title" }
    body { "MyText" }
  end

  trait :invalid_question do
    title { nil }
  end

  trait :with_file do
    files { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")] }
  end

  trait :with_link do
    links { [Link.new(url: 'https://test.com', name: 'test')] }
  end

  trait :with_reward do
    reward { Reward.new(name: 'reward', file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/ec08c343da0011779330e0ed7d7313f6e0bfb50d_full.jpg")) }
  end
end
