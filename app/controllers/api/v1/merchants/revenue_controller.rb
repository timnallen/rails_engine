class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    render json: RevenueSerializer.new(Merchant.revenue_by_date(params[:date]))
  end
end
