class Transaction < ApplicationRecord
  belongs_to :invoice

  validates_presence_of :invoice
  validates_presence_of :result
  validates_presence_of :credit_card_number
end
