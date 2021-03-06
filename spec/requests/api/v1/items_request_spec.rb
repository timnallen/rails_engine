require 'rails_helper'

describe "Items API" do
  before :each do
    @customer = create(:customer)
    @merchant_1 = create(:merchant, name: "M1")
    @item_1 = create(:item, merchant: @merchant_1, unit_price: 100)
    @item_2 = create(:item, merchant: @merchant_1, unit_price: 200)
    @item_3 = create(:item, merchant: @merchant_1, unit_price: 300)
    @invoice_1 = create(:invoice, created_at: "2012-03-27 14:54:05 UTC", merchant: @merchant_1, customer: @customer)
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 10, unit_price: @item_1.unit_price)
    create(:invoice_item, item: @item_2, invoice: @invoice_1, quantity: 10, unit_price: @item_2.unit_price)
    create(:invoice_item, item: @item_3, invoice: @invoice_1, quantity: 10, unit_price: @item_3.unit_price)
    @merchant_2 = create(:merchant, name: "M2")
    @item_4 = create(:item, merchant: @merchant_2, unit_price: 400)
    @item_5 = create(:item, merchant: @merchant_2, unit_price: 500)
    @item_6 = create(:item, merchant: @merchant_2, unit_price: 600)
    @invoice_2 = create(:invoice, created_at: "2012-03-27 14:54:09 UTC", merchant: @merchant_2, customer: @customer)
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
    @transaction_1 = create(:transaction, invoice: @invoice_1)
    @transaction_2 = create(:transaction, invoice: @invoice_2)
    @transaction_3 = create(:transaction, invoice: @invoice_3)
    @transaction_4 = create(:transaction, invoice: @invoice_4, result: 'failed')
  end

  describe 'record endpoints' do
    it "can get a list of items" do
      get '/api/v1/items'

      expect(response).to be_successful
      items = JSON.parse(response.body)
      expect(items['data'].count).to eq(12)
    end

    it "can get one item by its id" do
      id = @item_1.id.to_s

      get "/api/v1/items/#{id}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item['data']["id"]).to eq(id)
    end

    it "can get one item by searching its id" do
      id = @item_1.id.to_s

      get "/api/v1/items/find?id=#{id}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item['data']["id"]).to eq(id)
    end

    it "can get one item by searching its name" do
      name = create(:item).name

      get "/api/v1/items/find?name=#{name}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item['data']['attributes']["name"]).to eq(name)
    end

    it "can get one item by searching its description" do
      description = create(:item, description: "This specific one").description

      get "/api/v1/items/find?description=#{description}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item['data']['attributes']["description"]).to eq(description)
    end

    it "can get one item by searching its unit_price" do
      create(:item, unit_price: 1121)

      get "/api/v1/items/find?unit_price=#{11.21}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item['data']['attributes']["unit_price"]).to eq("11.21")
    end

    it "can get one item by searching its created_at date" do
      item = create(:item, created_at: "2012-03-27 14:54:10 UTC")

      get "/api/v1/items/find?created_at=#{item.created_at}"

      item_json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item_json['data']['attributes']['name']).to eq(item.name)
      expect(item_json['data']['id']).to eq(item.id.to_s)
    end

    it "can get one item by searching its updated_at date" do
      item = create(:item, updated_at: "2012-03-27 14:54:10 UTC")

      get "/api/v1/items/find?updated_at=#{item.updated_at}"

      item_json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item_json['data']['attributes']['name']).to eq(item.name)
      expect(item_json['data']['id']).to eq(item.id.to_s)
    end

    it 'can get all items by searching by id, name, unit_price or description' do
      id = create(:item, name: "Practice name", unit_price: 4000, description: "describe this").id.to_s

      get "/api/v1/items/find_all?id=#{id}"

      items = JSON.parse(response.body)

      expect(response).to be_successful
      expect(items['data'][0]["id"]).to eq(id)

      name = create(:item, name: "Practice name", unit_price: 4000, description: "describe this").name

      get "/api/v1/items/find_all?name=#{name}"

      items = JSON.parse(response.body)

      expect(response).to be_successful
      expect(items['data'][0]['attributes']["name"]).to eq(name)
      expect(items['data'][1]['attributes']["name"]).to eq(name)
      expect(items['data'].count).to eq(2)

      description = create(:item, name: "Practice name", unit_price: 4000, description: "describe this").description

      get "/api/v1/items/find_all?description=#{description}"

      items = JSON.parse(response.body)

      expect(response).to be_successful
      expect(items['data'][0]['attributes']["description"]).to eq(description)
      expect(items['data'][1]['attributes']["description"]).to eq(description)
      expect(items['data'][2]['attributes']["description"]).to eq(description)
      expect(items['data'].count).to eq(3)
    end

    it 'can get all items by searching by created_at or updated_at' do
      item = create(:item, created_at: "2012-04-27 14:54:10 UTC", updated_at: "2012-04-27 14:54:10 UTC".to_datetime)

      get "/api/v1/items/find_all?created_at=#{item.created_at}"

      items = JSON.parse(response.body)

      expect(response).to be_successful
      expect(items['data'][0]["id"]).to eq(item.id.to_s)

      item_2 = create(:item, updated_at: "2012-04-27 14:54:10 UTC")

      get "/api/v1/items/find_all?updated_at=#{item_2.updated_at}"

      items = JSON.parse(response.body)

      expect(response).to be_successful
      expect(items['data'][0]["id"]).to eq(item.id.to_s)
      expect(items['data'][1]["id"]).to eq(item_2.id.to_s)
      expect(items['data'].count).to eq(2)
    end

    it 'can get a random item' do
      get "/api/v1/items/random"

      item = JSON.parse(response.body)

      id_strings = Item.all.map do |item|
        item.id.to_s
      end

      expect(response).to be_successful
      expect(item['data']["id"]).to be_in(id_strings)
    end
  end

  describe 'relationship endpoints' do
    it 'can get a list of associated invoice items' do
      invoice_2 = create(:invoice, merchant: @merchant_1, customer: @customer)
      invoice_item_2 = create(:invoice_item, item: @item_1, invoice: invoice_2, unit_price: @item_1.unit_price)

      get "/api/v1/items/#{@item_1.id}/invoice_items"

      invoice_items = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(invoice_items[0]['id']).to eq(@invoice_item_1.id.to_s)
      expect(invoice_items[1]['id']).to eq(invoice_item_2.id.to_s)
    end

    it 'can get the associated merchant for an item' do
      get "/api/v1/items/#{@item_1.id}/merchant"

      merchant = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(merchant['id']).to eq(@merchant_1.id.to_s)
      expect(merchant['attributes']['name']).to eq("M1")
    end
  end

  describe 'business intelligence' do
    it 'gets the top x items ranked by revenue generated' do
      get '/api/v1/items/most_revenue?quantity=4'

      items = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(items[0]['id']).to eq(@item_3.id.to_s)
      expect(items[1]['id']).to eq(@item_2.id.to_s)
      expect(items[2]['id']).to eq(@item_1.id.to_s)
      expect(items[3]['id']).to eq(@item_9.id.to_s)
    end

    it 'gets the top x items ranked by items sold' do
      invoice_5 = create(:invoice, merchant: @merchant_1, customer: @customer)
      create(:invoice_item, invoice: invoice_5, item: @item_1, quantity: 5)
      create(:invoice_item, invoice: invoice_5, item: @item_2, quantity: 3)
      invoice_6 = create(:invoice, merchant: @merchant_3, customer: @customer)
      create(:invoice_item, invoice: invoice_6, item: @item_7, quantity: 3)
      create(:transaction, invoice: invoice_5)
      create(:transaction, invoice: invoice_6)

      get '/api/v1/items/most_items?quantity=4'

      items = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(items[0]['id']).to eq(@item_1.id.to_s)
      expect(items[1]['id']).to eq(@item_2.id.to_s)
      expect(items[2]['id']).to eq(@item_3.id.to_s)
      expect(items[3]['id']).to eq(@item_7.id.to_s)
    end

    it 'gets the date with the most sales for the given item' do
      invoice_5 = create(:invoice, merchant: @merchant_1, customer: @customer, created_at: "2012-03-23T10:55:29.000Z")
      create(:invoice_item, invoice: invoice_5, item: @item_1)
      invoice_6 = create(:invoice, merchant: @merchant_1, customer: @customer, created_at: "2012-03-23T10:55:29.000Z")
      create(:invoice_item, invoice: invoice_6, item: @item_1)
      invoice_7 = create(:invoice, merchant: @merchant_1, customer: @customer, created_at: "2012-03-23T10:55:29.000Z")
      create(:invoice_item, invoice: invoice_7, item: @item_1)
      invoice_8 = create(:invoice, merchant: @merchant_1, customer: @customer, created_at: "2012-03-27 14:54:05 UTC")
      create(:invoice_item, invoice: invoice_8, item: @item_1)

      get "/api/v1/items/#{@item_1.id}/best_day"

      date = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(date['attributes']['best_day']).to eq("2012-03-27")
    end
  end
end
