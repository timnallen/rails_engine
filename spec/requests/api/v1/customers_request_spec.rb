require 'rails_helper'

describe "Customers API" do
  describe 'record endpoints' do
    it "can get a list of customers" do
      create_list(:customer, 3)

      get '/api/v1/customers'

      expect(response).to be_successful
      customers = JSON.parse(response.body)
      expect(customers['data'].count).to eq(3)
    end

    it "can get one customer by its id" do
      id = create(:customer).id.to_s

      get "/api/v1/customers/#{id}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer['data']["id"]).to eq(id)
    end

    it "can get one customer by searching its id" do
      id = create(:customer).id.to_s

      get "/api/v1/customers/find?id=#{id}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer['data']["id"]).to eq(id)
    end

    it "can get one customer by searching its first name" do
      first_name = create(:customer).first_name

      get "/api/v1/customers/find?first_name=#{first_name}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer['data']['attributes']["first_name"]).to eq(first_name)
    end

    it "can get one customer by searching its last name" do
      last_name = create(:customer).last_name

      get "/api/v1/customers/find?last_name=#{last_name}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer['data']['attributes']["last_name"]).to eq(last_name)
    end

    it "can get one customer by searching its created_at date" do
      customer = create(:customer, created_at: "2012-03-27 14:54:05 UTC")

      get "/api/v1/customers/find?created_at=#{customer.created_at}"

      customer_json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer_json['data']['attributes']['first_name']).to eq(customer.first_name)
      expect(customer_json['data']['id']).to eq(customer.id.to_s)
    end

    it "can get one customer by searching its updated_at date" do
      customer = create(:customer, updated_at: "2012-03-27 14:54:05 UTC")

      get "/api/v1/customers/find?updated_at=#{customer.updated_at}"

      customer_json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer_json['data']['attributes']['first_name']).to eq(customer.first_name)
      expect(customer_json['data']['id']).to eq(customer.id.to_s)
    end

    it 'can get all customers by searching by id or name' do
      id = create(:customer).id.to_s

      get "/api/v1/customers/find_all?id=#{id}"

      customers = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customers['data'][0]["id"]).to eq(id)

      first_name = create(:customer).first_name

      get "/api/v1/customers/find_all?first_name=#{first_name}"

      customers = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customers['data'][0]['attributes']["first_name"]).to eq(first_name)
      expect(customers['data'][1]['attributes']["first_name"]).to eq(first_name)
      expect(customers['data'].count).to eq(2)
    end

    it 'can get all customers by searching by created_at or updated_at' do
      customer = create(:customer, created_at: "2012-03-27 14:54:05 UTC", updated_at: "2012-03-27 14:54:05 UTC".to_datetime)

      get "/api/v1/customers/find_all?created_at=#{customer.created_at}"

      customers = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customers['data'][0]['attributes']["first_name"]).to eq(customer.first_name)

      customer_2 = create(:customer, updated_at: "2012-03-27 14:54:05 UTC")

      get "/api/v1/customers/find_all?updated_at=#{customer_2.updated_at}"

      customers = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customers['data'][0]['attributes']["first_name"]).to eq(customer.first_name)
      expect(customers['data'][1]['attributes']["first_name"]).to eq(customer_2.first_name)
      expect(customers['data'].count).to eq(2)
    end

    it 'can get a random customer' do
      id = create(:customer).id.to_s

      get "/api/v1/customers/random"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer['data']["id"]).to eq(id)

      id_2 = create(:customer).id.to_s

      get "/api/v1/customers/random"

      customer_2 = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer_2['data']["id"]).to be_in([id, id_2])
    end
  end

  describe 'relationship endpoints' do
    before :each do
      @customer = create(:customer)
      @customer_2 = create(:customer)
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
