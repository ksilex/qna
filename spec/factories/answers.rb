FactoryBot.define do
  sequence :body do |n|
    "text#{n}"
  end
  factory :answer do
    user
    body
    question
  end

  trait :invalid_answer do
    body { nil }
  end
end
