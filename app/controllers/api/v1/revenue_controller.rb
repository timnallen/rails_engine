class Api::V1::RevenueController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: RevenueSerializer.new(merchant.revenue)
  end
end
