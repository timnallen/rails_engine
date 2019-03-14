class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :merchant
  validates_presence_of :unit_price

  def self.by_revenue(limit)
    Item.joins(:invoice_items, invoices: :transactions)
        .select("items.*, SUM(invoice_items.quantity*invoice_items.unit_price) as total_revenue")
        .group(:id)
        .merge(Transaction.unscoped.successful)
        .order("total_revenue DESC")
        .limit(limit)
  end

  def self.by_items_sold(limit)
    Item.joins(:invoice_items, invoices: :transactions)
        .select("items.*, SUM(invoice_items.quantity) as total_items")
        .group(:id)
        .merge(Transaction.unscoped.successful)
        .order("total_items DESC")
        .limit(limit)
  end
end
