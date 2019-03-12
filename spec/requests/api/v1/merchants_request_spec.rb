require 'rails_helper'

describe "Merchants API" do
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

  it 'can get the top x merchants ranked by total revenue' do

  end
end
