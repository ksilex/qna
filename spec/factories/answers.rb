FactoryBot.define do
  factory :answer do
    body { "MyText" }
    association :question
  end

  trait :invalid_answer do
    body { nil }
  end
end
