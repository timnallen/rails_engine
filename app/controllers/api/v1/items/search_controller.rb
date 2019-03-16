class Api::V1::Items::SearchController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.where(price_converter(item_params)))
  end

  def show
    render json: ItemSerializer.new(Item.find_by(price_converter(item_params)))
  end

  private

  def item_params
    params.permit(:id, :name, :description, :merchant_id, :unit_price, :created_at, :updated_at)
  end
end
