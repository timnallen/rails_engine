class Api::V1::Customers::RandomController < ApplicationController
  def show
    render json: CustomerSerializer.new(Customer.order(Arel.sql("RANDOM()")).limit(1).first)
  end
end
