require 'rails_helper'

describe 'Transactions API' do
  describe 'record endpoints' do
    it "can get a list of transactions" do
      create_list(:transaction, 3)

      get '/api/v1/transactions'

      expect(response).to be_successful
      transactions = JSON.parse(response.body)
      expect(transactions['data'].count).to eq(3)
    end

    it "can get one transaction by its id" do
      id = create(:transaction).id.to_s

      get "/api/v1/transactions/#{id}"

      transaction = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transaction['data']["id"]).to eq(id)
    end

    it "can get one transaction by searching its id" do
      id = create(:transaction).id.to_s

      get "/api/v1/transactions/find?id=#{id}"

      transaction = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transaction['data']["id"]).to eq(id)
    end

    it "can get one transaction by searching its credit_card_number" do
      credit_card_number = create(:transaction).credit_card_number

      get "/api/v1/transactions/find?credit_card_number=#{credit_card_number}"

      transaction = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transaction['data']['attributes']["credit_card_number"]).to eq(credit_card_number)
    end

    it "can get one transaction by searching its credit_card_expiration_date" do
      transaction = create(:transaction, credit_card_number: "4560987567409856")

      get "/api/v1/transactions/find?credit_card_expiration_date=#{transaction.credit_card_expiration_date}"

      transaction_json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transaction_json['data']['attributes']["credit_card_number"]).to eq(transaction.credit_card_number)
    end

    it "can get one transaction by searching its result" do
      result = create(:transaction).result

      get "/api/v1/transactions/find?result=#{result}"

      transaction = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transaction['data']['attributes']["result"]).to eq(result)
    end

    it "can get one transaction by searching its created_at date" do
      transaction = create(:transaction, created_at: "2012-03-27 14:54:10 UTC")

      get "/api/v1/transactions/find?created_at=#{transaction.created_at}"

      item_json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item_json['data']['attributes']['credit_card_number']).to eq(transaction.credit_card_number)
      expect(item_json['data']['id']).to eq(transaction.id.to_s)
    end

    it "can get one transaction by searching its updated_at date" do
      transaction = create(:transaction, updated_at: "2012-03-27 14:54:10 UTC")

      get "/api/v1/transactions/find?updated_at=#{transaction.updated_at}"

      item_json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item_json['data']['attributes']['credit_card_number']).to eq(transaction.credit_card_number)
      expect(item_json['data']['id']).to eq(transaction.id.to_s)
    end

    it 'can get all transactions by searching by id, credit_card_number, result or credit_card_expiration_date' do
      id = create(:transaction).id.to_s

      get "/api/v1/transactions/find_all?id=#{id}"

      transactions = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transactions['data'][0]["id"]).to eq(id)

      credit_card_number = create(:transaction).credit_card_number

      get "/api/v1/transactions/find_all?credit_card_number=#{credit_card_number}"

      transactions = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transactions['data'][0]['attributes']["credit_card_number"]).to eq(credit_card_number)
      expect(transactions['data'][1]['attributes']["credit_card_number"]).to eq(credit_card_number)
      expect(transactions['data'].count).to eq(2)

      transaction_2 = create(:transaction)

      get "/api/v1/transactions/find_all?credit_card_expiration_date=#{transaction_2.credit_card_expiration_date}"

      transactions = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transactions['data'][0]['attributes']["credit_card_number"]).to eq(credit_card_number)
      expect(transactions['data'][1]['attributes']["credit_card_number"]).to eq(credit_card_number)
      expect(transactions['data'][2]['attributes']["credit_card_number"]).to eq(credit_card_number)
      expect(transactions['data'].count).to eq(3)
    end

    it 'can get all transactions by searching by created_at or updated_at' do
      transaction = create(:transaction, created_at: "2012-04-27 14:54:10 UTC", updated_at: "2012-04-27 14:54:10 UTC".to_datetime)

      get "/api/v1/transactions/find_all?created_at=#{transaction.created_at}"

      transactions = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transactions['data'][0]["id"]).to eq(transaction.id.to_s)

      transaction_2 = create(:transaction, updated_at: "2012-04-27 14:54:10 UTC")

      get "/api/v1/transactions/find_all?updated_at=#{transaction_2.updated_at}"

      transactions = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transactions['data'][0]["id"]).to eq(transaction.id.to_s)
      expect(transactions['data'][1]["id"]).to eq(transaction_2.id.to_s)
      expect(transactions['data'].count).to eq(2)
    end

    it 'can get a random transaction' do
      id = create(:transaction).id.to_s

      get "/api/v1/transactions/random"

      transaction = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transaction['data']["id"]).to eq(id)

      id_2 = create(:transaction).id.to_s

      get "/api/v1/transactions/random"

      transaction_2 = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transaction_2['data']["id"]).to be_in([id, id_2])
    end
  end

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
