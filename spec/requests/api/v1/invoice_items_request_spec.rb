require 'rails_helper'

describe 'Invoice Items API' do
  describe 'record endpoints' do
    it "can get a list of invoice_items" do
      create_list(:invoice_item, 3)

      get '/api/v1/invoice_items'

      expect(response).to be_successful
      invoice_items = JSON.parse(response.body)
      expect(invoice_items['data'].count).to eq(3)
    end

    it "can get one invoice_item by its id" do
      id = create(:invoice_item).id.to_s

      get "/api/v1/invoice_items/#{id}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item['data']["id"]).to eq(id)
    end

    it "can get one invoice_item by searching its id" do
      id = create(:invoice_item).id.to_s

      get "/api/v1/invoice_items/find?id=#{id}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item['data']["id"]).to eq(id)
    end

    it "can get one invoice_item by searching its quantity" do
      quantity = create(:invoice_item).quantity

      get "/api/v1/invoice_items/find?quantity=#{quantity}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item['data']['attributes']["quantity"]).to eq(quantity)
    end

    it "can get one invoice_item by searching its unit price" do
      unit_price = create(:invoice_item).unit_price

      get "/api/v1/invoice_items/find?unit_price=#{unit_price}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item['data']['attributes']["unit_price"]).to eq(unit_price)
    end

    it "can get one invoice_item by searching its created_at date" do
      invoice_item = create(:invoice_item, created_at: "2012-03-27 14:54:05 UTC")

      get "/api/v1/invoice_items/find?created_at=#{invoice_item.created_at}"

      customer_json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer_json['data']['attributes']['quantity']).to eq(invoice_item.quantity)
      expect(customer_json['data']['id']).to eq(invoice_item.id.to_s)
    end

    it "can get one invoice_item by searching its updated_at date" do
      invoice_item = create(:invoice_item, updated_at: "2012-03-27 14:54:05 UTC")

      get "/api/v1/invoice_items/find?updated_at=#{invoice_item.updated_at}"

      customer_json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer_json['data']['attributes']['quantity']).to eq(invoice_item.quantity)
      expect(customer_json['data']['id']).to eq(invoice_item.id.to_s)
    end

    it 'can get all invoice_items by searching by id, quantity, or unit_price' do
      id = create(:invoice_item).id.to_s

      get "/api/v1/invoice_items/find_all?id=#{id}"

      invoice_items = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_items['data'][0]["id"]).to eq(id)

      quantity = create(:invoice_item).quantity

      get "/api/v1/invoice_items/find_all?quantity=#{quantity}"

      invoice_items = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_items['data'][0]['attributes']["quantity"]).to eq(quantity)
      expect(invoice_items['data'][1]['attributes']["quantity"]).to eq(quantity)
      expect(invoice_items['data'].count).to eq(2)

      unit_price = create(:invoice_item).unit_price

      get "/api/v1/invoice_items/find_all?unit_price=#{unit_price}"

      invoice_items = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_items['data'][0]['attributes']["unit_price"]).to eq(unit_price)
      expect(invoice_items['data'][1]['attributes']["unit_price"]).to eq(unit_price)
      expect(invoice_items['data'][2]['attributes']["unit_price"]).to eq(unit_price)
      expect(invoice_items['data'].count).to eq(3)
    end

    it 'can get all invoice_items by searching by created_at or updated_at' do
      invoice_item = create(:invoice_item, created_at: "2012-03-27 14:54:05 UTC", updated_at: "2012-03-27 14:54:05 UTC".to_datetime)

      get "/api/v1/invoice_items/find_all?created_at=#{invoice_item.created_at}"

      invoice_items = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_items['data'][0]["id"]).to eq(invoice_item.id.to_s)

      invoice_item_2 = create(:invoice_item, updated_at: "2012-03-27 14:54:05 UTC")

      get "/api/v1/invoice_items/find_all?updated_at=#{invoice_item_2.updated_at}"

      invoice_items = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_items['data'][0]["id"]).to eq(invoice_item.id.to_s)
      expect(invoice_items['data'][1]["id"]).to eq(invoice_item_2.id.to_s)
      expect(invoice_items['data'].count).to eq(2)
    end

    it 'can get a random invoice_item' do
      id = create(:invoice_item).id.to_s

      get "/api/v1/invoice_items/random"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item['data']["id"]).to eq(id)

      id_2 = create(:invoice_item).id.to_s

      get "/api/v1/invoice_items/random"

      customer_2 = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer_2['data']["id"]).to be_in([id, id_2])
    end
  end

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
