FactoryBot.define do
  factory :invoice do
    name { "MyString" }
    customer { nil }
    merchant { nil }
    status { "MyString" }
    created_at { "2012-03-27 14:54:09 UTC" }
    updated_at { "2012-03-27 14:54:09 UTC" }
  end
end
