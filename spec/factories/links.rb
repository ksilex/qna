FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://test.com" }
    parent { nil }
  end
end
