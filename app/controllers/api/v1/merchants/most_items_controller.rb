class Api::V1::Merchants::MostItemsController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.merchants_by_items(params["quantity"]))
  end
end
