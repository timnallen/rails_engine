class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  validates_presence_of :name

  def self.merchants_by_revenue(limit)
    Merchant.joins(invoices: :invoice_items)
            .select("merchants.*, SUM(invoice_items.quantity*invoice_items.unit_price) as total_revenue")
            .joins('INNER JOIN transactions ON "invoice_items"."invoice_id" = "transactions"."invoice_id"')
            .where(transactions: {result: "success"})
            .group(:id)
            .order("total_revenue desc")
            .limit(limit)
  end
end
