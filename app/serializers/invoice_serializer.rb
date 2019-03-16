class InvoiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :status, :customer_id, :merchant_id
end
