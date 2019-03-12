class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  validates_presence_of :item
  validates_presence_of :invoice
  validates_presence_of :unit_price
  validates_presence_of :quantity
end
