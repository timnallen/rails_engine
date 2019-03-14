class Customer < ApplicationRecord
  has_many :invoices

  validates_presence_of :first_name
  validates_presence_of :last_name

  default_scope { order(:id) }

  def favorite_merchant
    invoices.joins(:merchant, :transactions)
            .select("merchants.*, COUNT(invoices.id) as invoice_count")
            .group("merchants.id")
            .merge(Transaction.unscoped.successful)
            .order("invoice_count DESC")
            .first
  end
end
