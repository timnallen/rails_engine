class Api::V1::CustomersController < ApplicationController
  def show
    object = related_object_finder(params)
    render json: CustomerSerializer.new(object.customer)
  end
end
