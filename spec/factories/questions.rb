FactoryBot.define do
  factory :question do
    user
    title { "MyString" }
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
end
