FactoryBot.define do
  factory :transaction do
    credit_card_number { 1 }
    credit_card_expiration_date { 1 }
    result { "MyString" }
    invoice { nil }
    created_at { "2012-03-27 14:54:09 UTC" }
    updated_at { "2012-03-27 14:54:09 UTC" }
  end
end
