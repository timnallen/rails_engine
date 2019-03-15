class Api::V1::ItemsController < ApplicationController
  def index
    object = object_finder(params)
    render json: ItemSerializer.new(object.items)
  end
end
