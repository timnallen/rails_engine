require 'rails_helper'

describe 'Invoice Items API' do
  describe 'relationship endpoints' do
    before :each do
      customer = create(:customer)
      merchant = create(:merchant)
      @invoice = create(:invoice, merchant: merchant, customer: customer)
      @item = create(:item, merchant: merchant)
      @invoice_item = create(:invoice_item, item: @item, invoice: @invoice)
    end

    it 'can get the associated invoice for an invoice_item' do
      get "/api/v1/invoice_items/#{@invoice_item.id}/invoice"

      invoice = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(invoice['id']).to eq(@invoice.id.to_s)
    end

    it 'can get the associated item for an invoice_item' do
      get "/api/v1/invoice_items/#{@invoice_item.id}/item"

      item = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(item['id']).to eq(@item.id.to_s)
    end
  end
end
