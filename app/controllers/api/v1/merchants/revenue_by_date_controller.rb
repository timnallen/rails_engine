class Api::V1::Merchants::RevenueByDateController < ApplicationController
  def show
    render json: RevenueSerializer.new(Merchant.revenue_by_date(params[:date]))
  end
end
