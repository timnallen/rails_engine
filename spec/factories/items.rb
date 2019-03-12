FactoryBot.define do
  factory :item do
    name { "MyItem" }
    description { "MyText" }
    unit_price { 100 }
    merchant { nil }
  end
end
