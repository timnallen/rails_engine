class Api::V1::Merchants::RandomController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.order(Arel.sql("RANDOM()")).limit(1).first)
  end
end
