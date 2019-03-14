class Api::V1::BestDayController < ApplicationController
  def show
    item = Item.find(params[:item_id])
    render json: DateSerializer.new(item.best_day)
  end
end
