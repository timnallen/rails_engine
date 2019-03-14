require 'rails_helper'

describe "Merchants API" do
  describe 'record endpoints' do
    it "sends a list of merchants" do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful
      merchants = JSON.parse(response.body)
      expect(merchants['data'].count).to eq(3)
    end

    it "can get one merchant by its id" do
      id = create(:merchant).id.to_s

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant['data']["id"]).to eq(id)
    end

    it "can get one merchant by searching its id" do
      id = create(:merchant).id.to_s

      get "/api/v1/merchants/find?id=#{id}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant['data']["id"]).to eq(id)
    end

    it "can get one merchant by searching its name" do
      name = create(:merchant).name

      get "/api/v1/merchants/find?name=#{name}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant['data']['attributes']["name"]).to eq(name)
    end

    it "can get one merchant by searching its created_at date" do
      created_at = create(:merchant, created_at: "2012-03-27 14:54:05 UTC").created_at

      get "/api/v1/merchants/find?created_at=#{created_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant['data']['attributes']["created_at"]).to eq("2012-03-27T14:54:05.000Z")
    end

    it "can get one merchant by searching its updated_at date" do
      updated_at = create(:merchant, updated_at: "2012-03-27 14:54:05 UTC").updated_at

      get "/api/v1/merchants/find?updated_at=#{updated_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant['data']['attributes']["updated_at"]).to eq("2012-03-27T14:54:05.000Z")
    end

    it 'can get all merchants by searching by id or name' do
      id = create(:merchant).id.to_s

      get "/api/v1/merchants/find_all?id=#{id}"

      merchants = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchants['data'][0]["id"]).to eq(id)

      name = create(:merchant).name

      get "/api/v1/merchants/find_all?name=#{name}"

      merchants = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchants['data'][0]['attributes']["name"]).to eq(name)
      expect(merchants['data'][1]['attributes']["name"]).to eq(name)
      expect(merchants['data'].count).to eq(2)
    end

    it 'can get all merchants by searching by created_at or updated_at' do
      created_at = create(:merchant, created_at: "2012-03-27 14:54:05 UTC", updated_at: "2012-03-27 14:54:05 UTC".to_datetime).created_at

      get "/api/v1/merchants/find_all?created_at=#{created_at}"

      merchants = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchants['data'][0]['attributes']["created_at"]).to eq("2012-03-27T14:54:05.000Z")

      updated_at = create(:merchant, updated_at: "2012-03-27 14:54:05 UTC").updated_at

      get "/api/v1/merchants/find_all?updated_at=#{updated_at}"

      merchants = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchants['data'][0]['attributes']["updated_at"]).to eq("2012-03-27T14:54:05.000Z")
      expect(merchants['data'][1]['attributes']["updated_at"]).to eq("2012-03-27T14:54:05.000Z")
      expect(merchants['data'].count).to eq(2)
    end

    it 'can get a random merchant' do
      id = create(:merchant).id.to_s

      get "/api/v1/merchants/random"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant['data']["id"]).to eq(id)

      id_2 = create(:merchant).id.to_s

      get "/api/v1/merchants/random"

      merchant_2 = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant_2['data']["id"]).to be_in([id, id_2])
    end
  end

  describe 'business intelligence' do
    before :each do
      @customer = create(:customer)
      @merchant_1 = create(:merchant, name: "M1")
      @item_1 = create(:item, merchant: @merchant_1, unit_price: 100)
      @item_2 = create(:item, merchant: @merchant_1, unit_price: 200)
      @item_3 = create(:item, merchant: @merchant_1, unit_price: 300)
      @invoice_1 = create(:invoice, created_at: "2012-03-27 14:54:05 UTC", merchant: @merchant_1, customer: @customer)
      create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 10, unit_price: @item_1.unit_price)
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

    describe 'All Merchants' do
      it 'can get the top x merchants ranked by total revenue' do
        get "/api/v1/merchants/most_revenue?quantity=3"

        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants['data'].count).to eq(3)
        expect(merchants['data'][0]['attributes']['name']).to eq("M1")
        expect(merchants['data'][1]['attributes']['name']).to eq("M3")
        expect(merchants['data'][2]['attributes']['name']).to eq("M2")

        create(:transaction, credit_card_number: '0987654312345678', invoice: @invoice_4, result: 'success')

        get "/api/v1/merchants/most_revenue?quantity=3"

        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants['data'].count).to eq(3)
        expect(merchants['data'][0]['attributes']['name']).to eq("M1")
        expect(merchants['data'][1]['attributes']['name']).to eq("M4")
        expect(merchants['data'][2]['attributes']['name']).to eq("M3")
      end

      it 'can get the top x merchants ranked by total items' do
        customer_2 = create(:customer)
        invoice_5 = create(:invoice, merchant: @merchant_2, customer: customer_2)
        invoice_6 = create(:invoice, merchant: @merchant_3, customer: customer_2)
        invoice_7 = create(:invoice, merchant: @merchant_4, customer: customer_2)
        create(:invoice_item, item: @item_4, invoice: invoice_5, quantity: 2, unit_price: @item_4.unit_price)
        create(:invoice_item, item: @item_8, invoice: invoice_6, quantity: 1, unit_price: @item_8.unit_price)
        create(:invoice_item, item: @item_10, invoice: invoice_7, quantity: 6, unit_price: @item_10.unit_price)
        create(:transaction, invoice: invoice_5)
        create(:transaction, invoice: invoice_6)
        create(:transaction, invoice: invoice_7, result: 'failed')

        get "/api/v1/merchants/most_items?quantity=3"

        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants['data'].count).to eq(3)
        expect(merchants['data'][0]['attributes']['name']).to eq("M1")
        expect(merchants['data'][1]['attributes']['name']).to eq("M2")
        expect(merchants['data'][2]['attributes']['name']).to eq("M3")

        create(:transaction, invoice: invoice_7, result: 'success')

        get "/api/v1/merchants/most_items?quantity=3"

        merchants = JSON.parse(response.body)

        expect(response).to be_successful
        expect(merchants['data'].count).to eq(3)
        expect(merchants['data'][0]['attributes']['name']).to eq("M1")
        expect(merchants['data'][1]['attributes']['name']).to eq("M4")
        expect(merchants['data'][2]['attributes']['name']).to eq("M2")
      end

      it 'can get the total revenue for date x across all merchants' do
        date = @invoice_1.created_at.to_s[0..9]

        get "/api/v1/merchants/revenue?date=#{date}"

        revenue = JSON.parse(response.body)

        expect(response).to be_successful
        expect(revenue['data']['attributes']['revenue']).to eq("75.00")
      end
    end

    describe "One Merchant" do
      it 'can get the total revenue for that merchant across successful transactions' do
        invoice_5 = create(:invoice, merchant: @merchant_4, customer: @customer)
        create(:invoice_item, item: @item_11, invoice: invoice_5, unit_price: @item_11.unit_price)
        create(:invoice_item, item: @item_12, invoice: invoice_5, unit_price: @item_12.unit_price)
        create(:transaction, invoice: invoice_5, result: "success")

        get "/api/v1/merchants/#{@merchant_4.id}/revenue"

        revenue = JSON.parse(response.body)['data']

        expect(response).to be_successful
        expect(revenue['attributes']).to eq({'revenue' => "23.00"})
      end

      it 'can get the total revenue for that merchant across successful transactions for one date' do
        invoice_5 = create(:invoice, merchant: @merchant_4, created_at: "2012-03-16", customer: @customer)
        create(:invoice_item, item: @item_11, invoice: invoice_5, unit_price: @item_11.unit_price)
        create(:invoice_item, item: @item_12, invoice: invoice_5, unit_price: @item_12.unit_price)
        create(:transaction, invoice: invoice_5, result: "success")

        invoice_6 = create(:invoice, merchant: @merchant_4, created_at: "2012-03-28", customer: @customer)
        create(:invoice_item, item: @item_10, invoice: invoice_6, unit_price: @item_10.unit_price)
        create(:invoice_item, item: @item_12, invoice: invoice_6, unit_price: @item_12.unit_price)
        create(:transaction, invoice: invoice_6, result: "success")

        get "/api/v1/merchants/#{@merchant_4.id}/revenue?date=#{invoice_5.created_at}"

        revenue = JSON.parse(response.body)['data']

        expect(response).to be_successful
        expect(revenue['attributes']).to eq({'revenue' => "23.00"})
      end

      it 'can get the customer with the most successful transactions' do
        customer_2 = create(:customer, first_name: "Me", last_name: "Also me")
        customer_3 = create(:customer)
        invoice_5 = create(:invoice, merchant: @merchant_4, customer: customer_2)
        invoice_6 = create(:invoice, merchant: @merchant_4, customer: customer_3)
        invoice_7 = create(:invoice, merchant: @merchant_4, customer: customer_2)
        create(:invoice_item, item: @item_11, invoice: invoice_5, unit_price: @item_11.unit_price)
        create(:invoice_item, item: @item_11, invoice: invoice_6, unit_price: @item_11.unit_price)
        create(:invoice_item, item: @item_12, invoice: invoice_7, unit_price: @item_12.unit_price)
        create(:transaction, invoice: invoice_5, result: "success")
        create(:transaction, invoice: invoice_6, result: "success")
        create(:transaction, invoice: invoice_7, result: "success")
        create(:transaction, invoice: @invoice_4, result: 'failed')
        create(:transaction, invoice: @invoice_4, result: 'failed')
        create(:transaction, invoice: @invoice_4, result: 'failed')
        create(:transaction, invoice: @invoice_4, result: 'failed')


        get "/api/v1/merchants/#{@merchant_4.id}/favorite_customer"

        customer = JSON.parse(response.body)['data']

        expect(response).to be_successful
        expect(customer['attributes']).to eq({'first_name' => "Me", 'last_name' => "Also me"})
      end

      it 'can get a list of customers with unpaid invoices' do
        customer_2 = create(:customer)
        customer_3 = create(:customer, first_name: "Failed", last_name: "Transaction")
        customer_4 = create(:customer)
        customer_5 = create(:customer, first_name: "No", last_name: "Payment")
        invoice_5 = create(:invoice, customer: customer_2, merchant: @merchant_4)
        invoice_6 = create(:invoice, customer: customer_3, merchant: @merchant_4)
        invoice_7 = create(:invoice, customer: customer_4, merchant: @merchant_4)
        create(:invoice, customer: customer_5, merchant: @merchant_4)
        create(:transaction, invoice: invoice_5, result: 'success')
        create(:transaction, invoice: invoice_6, result: 'failed')
        create(:transaction, invoice: invoice_7, result: 'success')

        get "/api/v1/merchants/#{@merchant_4.id}/customers_with_pending_invoices"

        customers = JSON.parse(response.body)['data']

        expect(response).to be_successful
        expect(customers.count).to eq(3)
        expect(customers[0]['id']).to be_in([@customer.id.to_s, customer_3.id.to_s, customer_5.id.to_s])
        expect(customers[1]['id']).to be_in([@customer.id.to_s, customer_3.id.to_s, customer_5.id.to_s])
        expect(customers[2]['id']).to be_in([@customer.id.to_s, customer_3.id.to_s, customer_5.id.to_s])
      end
    end
  end
end
