FactoryBot.define do
  factory :transaction do
    credit_card_number { "1234567891234567" }
    credit_card_expiration_date { "" }
    result { "success" }
    invoice
  end
end
