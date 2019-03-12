FactoryBot.define do
  factory :transaction do
    credit_card_number { "1" }
    credit_card_expiration_date { "1" }
    result { "MyResult" }
    invoice { "success" }
  end
end
