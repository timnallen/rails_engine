require 'rails_helper'

describe "Invoices API" do
  describe 'record endpoints' do
    it "can get a list of invoices" do
      create_list(:invoice, 3)

      get '/api/v1/invoices'

      expect(response).to be_successful
      invoices = JSON.parse(response.body)
      expect(invoices['data'].count).to eq(3)
    end

    it "can get one invoice by its id" do
      id = create(:invoice).id.to_s

      get "/api/v1/invoices/#{id}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice['data']["id"]).to eq(id)
    end

    it "can get one invoice by searching its id" do
      id = create(:invoice).id.to_s

      get "/api/v1/invoices/find?id=#{id}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice['data']["id"]).to eq(id)
    end

    it "can get one invoice by searching its name" do
      name = create(:invoice).name

      get "/api/v1/invoices/find?name=#{name}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice['data']['attributes']["name"]).to eq(name)
    end

    it "can get one invoice by searching its status" do
      status = create(:invoice).status

      get "/api/v1/invoices/find?status=#{status}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice['data']['attributes']["status"]).to eq(status)
    end

    it "can get one invoice by searching its created_at date" do
      invoice = create(:invoice, created_at: "2012-03-27 14:54:05 UTC")

      get "/api/v1/invoices/find?created_at=#{invoice.created_at}"

      customer_json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer_json['data']['attributes']['name']).to eq(invoice.name)
      expect(customer_json['data']['id']).to eq(invoice.id.to_s)
    end

    it "can get one invoice by searching its updated_at date" do
      invoice = create(:invoice, updated_at: "2012-03-27 14:54:05 UTC")

      get "/api/v1/invoices/find?updated_at=#{invoice.updated_at}"

      customer_json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer_json['data']['attributes']['name']).to eq(invoice.name)
      expect(customer_json['data']['id']).to eq(invoice.id.to_s)
    end

    it 'can get all invoices by searching by id, name, or status' do
      id = create(:invoice).id.to_s

      get "/api/v1/invoices/find_all?id=#{id}"

      invoices = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoices['data'][0]["id"]).to eq(id)

      name = create(:invoice).name

      get "/api/v1/invoices/find_all?name=#{name}"

      invoices = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoices['data'][0]['attributes']["name"]).to eq(name)
      expect(invoices['data'][1]['attributes']["name"]).to eq(name)
      expect(invoices['data'].count).to eq(2)

      status = create(:invoice).status

      get "/api/v1/invoices/find_all?status=#{status}"

      invoices = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoices['data'][0]['attributes']["status"]).to eq(status)
      expect(invoices['data'][1]['attributes']["status"]).to eq(status)
      expect(invoices['data'][2]['attributes']["status"]).to eq(status)
      expect(invoices['data'].count).to eq(3)
    end

    it 'can get all invoices by searching by created_at or updated_at' do
      invoice = create(:invoice, created_at: "2012-03-27 14:54:05 UTC", updated_at: "2012-03-27 14:54:05 UTC".to_datetime)

      get "/api/v1/invoices/find_all?created_at=#{invoice.created_at}"

      invoices = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoices['data'][0]["id"]).to eq(invoice.id.to_s)

      invoice_2 = create(:invoice, updated_at: "2012-03-27 14:54:05 UTC")

      get "/api/v1/invoices/find_all?updated_at=#{invoice_2.updated_at}"

      invoices = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoices['data'][0]["id"]).to eq(invoice.id.to_s)
      expect(invoices['data'][1]["id"]).to eq(invoice_2.id.to_s)
      expect(invoices['data'].count).to eq(2)
    end

    it 'can get a random invoice' do
      id = create(:invoice).id.to_s

      get "/api/v1/invoices/random"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice['data']["id"]).to eq(id)

      id_2 = create(:invoice).id.to_s

      get "/api/v1/invoices/random"

      invoice_2 = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_2['data']["id"]).to be_in([id, id_2])
    end
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

    it 'can get the merchant for an invoice' do
      get "/api/v1/invoices/#{@invoice.id}/merchant"

      merchant = JSON.parse(response.body)['data']

      expect(response).to be_successful
      expect(merchant['id']).to eq(@merchant.id.to_s)
      expect(merchant['attributes']['name']).to eq('MyMerchant')
    end
  end
end
