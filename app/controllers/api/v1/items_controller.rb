class Api::V1::ItemsController < ApplicationController
  def index
    object = related_object_finder(params)
    render json: ItemSerializer.new(object.items)
  end

  def show
    object = related_object_finder(params)
    render json: ItemSerializer.new(object.item)
  end
end
