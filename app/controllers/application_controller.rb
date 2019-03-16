class ApplicationController < ActionController::API
  def price_converter(params)
    if params[:unit_price]
      params[:unit_price] = params[:unit_price].to_d
      params[:unit_price] *= 100
      params[:unit_price].to_i
    end
    params
  end
end
