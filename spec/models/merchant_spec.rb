require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
  end

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :invoices}
  end

  describe 'class methods' do
    before :each do
      @customer = create(:customer)
      @merchant_1 = create(:merchant, name: "M1")
      @item_1 = create(:item, merchant: @merchant_1, unit_price: 100)
      @item_2 = create(:item, merchant: @merchant_1, unit_price: 200)
      @item_3 = create(:item, merchant: @merchant_1, unit_price: 300)
      @invoice_1 = create(:invoice, merchant: @merchant_1, customer: @customer)
      create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 10, unit_price: @item_1.unit_price)
      create(:invoice_item, item: @item_2, invoice: @invoice_1, quantity: 10, unit_price: @item_2.unit_price)
      create(:invoice_item, item: @item_3, invoice: @invoice_1, quantity: 10, unit_price: @item_3.unit_price)
      @merchant_2 = create(:merchant, name: "M2")
      @item_4 = create(:item, merchant: @merchant_2, unit_price: 400)
      @item_5 = create(:item, merchant: @merchant_2, unit_price: 500)
      @item_6 = create(:item, merchant: @merchant_2, unit_price: 600)
      @invoice_2 = create(:invoice, merchant: @merchant_2, customer: @customer)
      create(:invoice_item, item: @item_4, invoice: @invoice_2, unit_price: @item_4.unit_price)
      create(:invoice_item, item: @item_5, invoice: @invoice_2, unit_price: @item_5.unit_price)
      create(:invoice_item, item: @item_6, invoice: @invoice_2, unit_price: @item_6.unit_price)
      @merchant_3 = create(:merchant, name: "M3")
      @item_7 = create(:item, merchant: @merchant_3, unit_price: 700)
      @item_8 = create(:item, merchant: @merchant_3, unit_price: 800)
      @item_9 = create(:item, merchant: @merchant_3, unit_price: 900)
      @invoice_3 = create(:invoice, merchant: @merchant_3, customer: @customer)
      create(:invoice_item, item: @item_7, invoice: @invoice_3, unit_price: @item_7.unit_price)
      create(:invoice_item, item: @item_8, invoice: @invoice_3, unit_price: @item_8.unit_price)
      create(:invoice_item, item: @item_9, invoice: @invoice_3, unit_price: @item_9.unit_price)
      @merchant_4 = create(:merchant, name: "M4")
      @item_10 = create(:item, merchant: @merchant_4, unit_price: 1000)
      @item_11 = create(:item, merchant: @merchant_4, unit_price: 1100)
      @item_12 = create(:item, merchant: @merchant_4, unit_price: 1200)
      @invoice_4 = create(:invoice, merchant: @merchant_4, customer: @customer)
      create(:invoice_item, item: @item_10, invoice: @invoice_4, unit_price: @item_10.unit_price)
      create(:invoice_item, item: @item_11, invoice: @invoice_4, unit_price: @item_11.unit_price)
      create(:invoice_item, item: @item_12, invoice: @invoice_4, unit_price: @item_12.unit_price)
      @transaction_1 = create(:transaction, created_at: "2012-03-27 14:54:05 UTC", invoice: @invoice_1)
      @transaction_2 = create(:transaction, created_at: "2012-03-27 14:54:05 UTC", invoice: @invoice_2)
      @transaction_3 = create(:transaction, invoice: @invoice_3)
      @transaction_4 = create(:transaction, invoice: @invoice_4, result: 'failed')
    end

    it '::merchants_by_revenue' do
      expect(Merchant.merchants_by_revenue(3)).to eq([@merchant_1, @merchant_3, @merchant_2])
    end

    it '::merchants_by_items' do
      customer_2 = create(:customer)
      invoice_5 = create(:invoice, merchant: @merchant_2, customer: customer_2)
      invoice_6 = create(:invoice, merchant: @merchant_3, customer: customer_2)
      invoice_7 = create(:invoice, merchant: @merchant_4, customer: customer_2)
      create(:invoice_item, item: @item_4, invoice: invoice_5, quantity: 2, unit_price: @item_4.unit_price)
      create(:invoice_item, item: @item_8, invoice: invoice_6, quantity: 1, unit_price: @item_8.unit_price)
      create(:invoice_item, item: @item_10, invoice: invoice_7, quantity: 6, unit_price: @item_10.unit_price)
      create(:transaction, invoice: invoice_5)
      create(:transaction, invoice: invoice_6)
      create(:transaction, invoice: invoice_7)

      expect(Merchant.merchants_by_items(3)).to eq([@merchant_1, @merchant_4, @merchant_2])
    end

    it '::revenue_by_date' do
      date = @transaction_1.created_at
      expect(Merchant.revenue_by_date(date).revenue).to eq(7500)
    end
  end
end
