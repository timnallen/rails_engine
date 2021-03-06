class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :item_id, :invoice_id, :quantity, :unit_price

  attribute :unit_price do |object|
    '%.2f' % (object.unit_price.to_f/100)
  end
end
