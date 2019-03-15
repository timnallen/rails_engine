class Api::V1::TransactionsController < ApplicationController
  def index
    object = related_object_finder(params)
    render json: TransactionSerializer.new(object.transactions)
  end
end
