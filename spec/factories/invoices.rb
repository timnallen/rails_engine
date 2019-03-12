FactoryBot.define do
  factory :invoice do
    name { "MyString" }
    customer { nil }
    merchant { nil }
    status { "MyString" }
  end
end
