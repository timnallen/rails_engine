require 'rails_helper'

describe "Invoices API" do
  describe 'record endpoints' do
  end

  describe 'relationship endpoints' do
    before :each do
      @customer = create(:customer)
      @merchant = create(:merchant)
      @item_1 = create(:item, merchant: @merchant)
      @item_2 = create(:item, merchant: @merchant)
      @invoice = create(:invoice, customer: @customer, merchant: @merchant)
      @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice)
      @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice)
      @transaction_1 = create(:transaction, invoice: @invoice, result: 'failed')
      @transaction_2 = create(:transaction, invoice: @invoice, result: 'success')
    end

    it 'can get all the transactions for an invoice' do
      get "/api/v1/invoices/#{@invoice.id}/transactions"

      transactions = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(transactions.count).to eq(2)
      expect(transactions[0]['id']).to eq(@transaction_1.id.to_s)
      expect(transactions[1]['id']).to eq(@transaction_2.id.to_s)
    end

    it 'can get all the invoice_items for an invoice' do
      get "/api/v1/invoices/#{@invoice.id}/invoice_items"

      invoice_items = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(invoice_items.count).to eq(2)
      expect(invoice_items[0]['id']).to eq(@invoice_item_1.id.to_s)
      expect(invoice_items[1]['id']).to eq(@invoice_item_2.id.to_s)
    end

    it 'can get all the items for an invoice' do
      get "/api/v1/invoices/#{@invoice.id}/items"

      items = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(items.count).to eq(2)
      expect(items[0]['id']).to eq(@item_1.id.to_s)
      expect(items[1]['id']).to eq(@item_2.id.to_s)
    end

    it 'can get the customer for an invoice' do
      get "/api/v1/invoices/#{@invoice.id}/customer"

      customer = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(customer['id']).to eq(@customer.id.to_s)
      expect(customer['attributes']).to eq({'first_name' => 'My', 'last_name' => 'Customer'})
    end
  end
end
