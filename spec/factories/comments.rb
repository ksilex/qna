FactoryBot.define do
  factory :comment do
    user { nil }
    body { "MyString" }
    parent { nil }
  end
end
