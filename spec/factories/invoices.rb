FactoryBot.define do
  factory :invoice do
    name { "MyInvoice" }
    customer
    merchant
    status { "shipped" }
  end
end
