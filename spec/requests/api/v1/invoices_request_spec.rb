require 'rails_helper'

describe "Invoices API" do
  describe 'record endpoints' do
  end

  describe 'relationship endpoints' do
    it 'can get all the transactions for an invoice' do
      customer = create(:customer)
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice, customer: customer, merchant: merchant)
      create(:invoice_item, item: item, invoice: invoice)
      transaction_1 = create(:transaction, invoice: invoice, result: 'failed')
      transaction_2 = create(:transaction, invoice: invoice, result: 'success')

      get "/api/v1/invoices/#{invoice.id}/transactions"

      transactions = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(transactions.count).to eq(2)
      expect(transactions[0]['id']).to eq(transaction_1.id.to_s)
      expect(transactions[1]['id']).to eq(transaction_2.id.to_s)
    end
  end
end
