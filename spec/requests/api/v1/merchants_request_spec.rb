require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants.count).to eq(3)
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end

  it "can get one merchant by searching its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/find?id=#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end

  it "can get one merchant by searching its name" do
    name = create(:merchant).name

    get "/api/v1/merchants/find?name=#{name}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["name"]).to eq(name)
  end

  it "can get one merchant by searching its created_at date" do
    created_at = create(:merchant).created_at

    get "/api/v1/merchants/find?created_at=#{created_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["created_at"]).to eq(created_at)
  end

  it "can get one merchant by searching its updated_at date" do
    updated_at = create(:merchant).updated_at

    get "/api/v1/merchants/find?updated_at=#{updated_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["updated_at"]).to eq(updated_at)
  end

  it 'can get all merchants by searching by id or name' do
    id = create(:merchant).id

    get "/api/v1/merchants/find_all?id=#{id}"

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants[0]["id"]).to eq(id)

    name = create(:merchant).name

    get "/api/v1/merchants/find_all?name=#{name}"

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants[0]["name"]).to eq(name)
    expect(merchants.count).to eq(2)
  end
end
