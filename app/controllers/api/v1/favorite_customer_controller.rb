class Api::V1::FavoriteCustomerController < ApplicationController
  def show
    merchant = Merchant.find(params[:merchant_id])
    render json: CustomerSerializer.new(merchant.favorite_customer)
  end
end
