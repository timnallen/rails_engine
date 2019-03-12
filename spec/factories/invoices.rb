FactoryBot.define do
  factory :invoice do
    name { "MyInvoice" }
    customer { nil }
    merchant { nil }
    status { "shipped" }
  end
end
