class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.merchants_by_revenue(params["quantity"]))
  end
end
