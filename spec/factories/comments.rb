FactoryBot.define do
  factory :comment do
    user
    body { "MyString" }
    parent { nil }
  end
end
