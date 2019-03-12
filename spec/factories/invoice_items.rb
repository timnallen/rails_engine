FactoryBot.define do
  factory :invoice_item do
    item { nil }
    invoice { nil }
    quantity { 1 }
    unit_price { 1 }
    created_at { "2012-03-27 14:54:09 UTC" }
    updated_at { "2012-03-27 14:54:09 UTC" }
  end
end
