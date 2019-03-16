require 'rails_helper'

describe 'Invoice Items API' do
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
