class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  validates_presence_of :name

  def self.merchants_by_revenue(limit)
    Merchant.joins(invoices: [:invoice_items, :transactions])
            .select("merchants.*, SUM(invoice_items.quantity*invoice_items.unit_price) as total_revenue")
            .merge(Transaction.unscoped.successful)
            .group(:id)
            .order("total_revenue desc")
            .limit(limit)
  end

  def self.merchants_by_items(limit)
    Merchant.joins(invoices: [:invoice_items, :transactions])
            .select("merchants.*, SUM(invoice_items.quantity) as total_items")
            .merge(Transaction.unscoped.successful)
            .group(:id)
            .order("total_items desc")
            .limit(limit)
  end

  def self.revenue_by_date(date)
    Merchant.joins(invoices: [:invoice_items, :transactions])
            .select("SUM(invoice_items.quantity*invoice_items.unit_price) as total_revenue")
            .merge(Transaction.unscoped.successful)
            .where("DATE(invoices.created_at) = ?", date)
            .group("DATE(invoices.created_at)")[0]
  end

  def revenue(date=nil)
    all_revenue = invoices.joins(:invoice_items, :transactions)
                          .select("SUM(invoice_items.quantity*invoice_items.unit_price) as total_revenue")
                          .merge(Transaction.unscoped.successful)
    if date
      all_revenue.where("DATE(invoices.created_at) = ?", date)
                 .group("DATE(invoices.created_at)")[0]
    else
      all_revenue[0]
    end
  end

  def favorite_customer
    invoices.joins(:transactions, :customer)
            .merge(Transaction.unscoped.successful)
            .select("customers.*, COUNT(invoices.customer_id) as invoice_count")
            .group("customers.id")
            .order("invoice_count desc")
            .limit(1)[0]
  end

  def customers_with_pending_invoices
    invoices.find_by_sql("SELECT customers.* FROM invoices INNER JOIN customers ON customers.id = invoices.customer_id LEFT OUTER JOIN transactions ON transactions.invoice_id = invoices.id GROUP BY customers.id EXCEPT SELECT customers.* FROM invoices INNER JOIN customers ON customers.id = invoices.customer_id LEFT OUTER JOIN transactions ON transactions.invoice_id = invoices.id WHERE invoices.merchant_id = #{self.id} AND transactions.result = 'success'")
  end
end
