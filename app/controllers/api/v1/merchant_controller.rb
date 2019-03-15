class Api::V1::MerchantController < ApplicationController
  def show
    object = related_object_finder(params)
    render json: MerchantSerializer.new(object.merchant)
  end
end
