FactoryBot.define do
  factory :vote do
    user { nil }
    vote_type { 1 }
    parent { nil }
  end
end
