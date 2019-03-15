require 'rails_helper'

describe 'Transactions API' do
  describe 'relationship endpoints' do
    it 'can get the associated invoice' do
      customer = create(:customer)
      merchant = create(:merchant)
      invoice = create(:invoice, merchant: merchant, customer: customer)
      item = create(:item, merchant: merchant)
      create(:invoice_item, item: item, invoice: invoice)
      transaction = create(:transaction, invoice: invoice)

      get "/api/v1/transactions/#{transaction.id}/invoice"

      invoice_return = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(invoice_return['id']).to eq(invoice.id.to_s)
    end
  end
end
