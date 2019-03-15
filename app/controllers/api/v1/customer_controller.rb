class Api::V1::CustomerController < ApplicationController
  def show
    object = related_object_finder(params)
    render json: CustomerSerializer.new(object.customer)
  end
end
