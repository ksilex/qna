FactoryBot.define do
  factory :vote do
    user
    vote_type { 1 }
    parent { nil }
  end
end
