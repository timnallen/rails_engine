require 'rails_helper'

describe "Customers API" do
  describe 'record endpoints' do
  end

  describe 'relationship endpoints' do
    before :each do
      @customer = create(:customer)
      @customer_2 = create(:customer)
      @merchant = create(:merchant)
      @merchant = create(:merchant)
      @invoice_1 = create(:invoice, customer: @customer, merchant: @merchant)
      @invoice_2 = create(:invoice, customer: @customer, merchant: @merchant)
      @invoice_3 = create(:invoice, customer: @customer, merchant: @merchant)
      create(:invoice, customer: @customer_2, merchant: @merchant)
    end

    it 'can get a collection of associated invoices' do
      get "/api/v1/customers/#{@customer.id}/invoices"

      invoices = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(invoices.count).to eq(3)
      expect(invoices[0]['id']).to eq(@invoice_1.id.to_s)
      expect(invoices[1]['id']).to eq(@invoice_2.id.to_s)
      expect(invoices[2]['id']).to eq(@invoice_3.id.to_s)
    end

    it 'can get a collection of associated transactions' do
      transaction_1 = create(:transaction, invoice: @invoice_1)
      transaction_2 = create(:transaction, invoice: @invoice_2)
      transaction_3 = create(:transaction, invoice: @invoice_3)

      get "/api/v1/customers/#{@customer.id}/transactions"

      transactions = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(transactions.count).to eq(3)
      expect(transactions[0]['id']).to eq(transaction_1.id.to_s)
      expect(transactions[1]['id']).to eq(transaction_2.id.to_s)
      expect(transactions[2]['id']).to eq(transaction_3.id.to_s)
    end
  end

  describe 'business intelligence' do
    it 'gets the merchant that the customer has the most successful transactions with' do
      @customer = create(:customer)
      @merchant_1 = create(:merchant, name: "M1")
      @item_2 = create(:item, merchant: @merchant_1, unit_price: 200)
      @invoice_1 = create(:invoice, created_at: "2012-03-27 14:54:05 UTC", merchant: @merchant_1, customer: @customer)
      create(:invoice_item, item: @item_2, invoice: @invoice_1, quantity: 10, unit_price: @item_2.unit_price)
      @merchant_2 = create(:merchant, name: "M2")
      @item_6 = create(:item, merchant: @merchant_2, unit_price: 600)
      @invoice_2 = create(:invoice, created_at: "2012-03-27 14:54:09 UTC", merchant: @merchant_2, customer: @customer)
      create(:invoice_item, item: @item_6, invoice: @invoice_2, unit_price: @item_6.unit_price)
      @merchant_3 = create(:merchant, name: "M3")
      @item_9 = create(:item, merchant: @merchant_3, unit_price: 900)
      @item_7 = create(:item, merchant: @merchant_3, unit_price: 700)
      @invoice_3 = create(:invoice, merchant: @merchant_3, customer: @customer)
      create(:invoice_item, item: @item_9, invoice: @invoice_3, unit_price: @item_7.unit_price)
      @merchant_4 = create(:merchant, name: "M4")
      @item_10 = create(:item, merchant: @merchant_4, unit_price: 1000)
      @invoice_4 = create(:invoice, merchant: @merchant_4, customer: @customer)
      create(:invoice_item, item: @item_10, invoice: @invoice_4, unit_price: @item_10.unit_price)
      @invoice_5 = create(:invoice, merchant: @merchant_3, customer: @customer)
      create(:invoice_item, item: @item_7, invoice: @invoice_5, unit_price: @item_7.unit_price)
      @transaction_1 = create(:transaction, invoice: @invoice_1)
      @transaction_2 = create(:transaction, invoice: @invoice_2)
      @transaction_3 = create(:transaction, invoice: @invoice_3)
      @transaction_4 = create(:transaction, invoice: @invoice_4, result: 'failed')
      @transaction_5 = create(:transaction, invoice: @invoice_4, result: 'failed')
      @transaction_6 = create(:transaction, invoice: @invoice_4, result: 'failed')
      @transaction_7 = create(:transaction, invoice: @invoice_5)

      get "/api/v1/customers/#{@customer.id}/favorite_merchant"

      merchant = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(merchant['id']).to eq(@merchant_3.id.to_s)
      expect(merchant['attributes']['name']).to eq(@merchant_3.name)
    end
  end
end
