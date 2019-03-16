class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    merchant = Merchant.find(params[:merchant_id])
    render json: RevenueSerializer.new(merchant.revenue(params[:date]))
  end
end
