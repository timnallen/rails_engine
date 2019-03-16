class Api::V1::InvoiceItems::SearchController < ApplicationController
  def index
    render json: InvoiceItemSerializer.new(InvoiceItem.where(price_converter(invoice_item_params)))
  end

  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.find_by(price_converter(invoice_item_params)))
  end

  private

  def invoice_item_params
    params.permit(:id, :quantity, :unit_price, :invoice_id, :item_id, :created_at, :updated_at)\
  end
end
