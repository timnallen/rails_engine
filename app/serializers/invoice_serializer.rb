class InvoiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :status, :customer_id, :merchant_id
end
