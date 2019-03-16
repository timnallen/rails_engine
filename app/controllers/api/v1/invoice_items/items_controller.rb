class Api::V1::InvoiceItems::ItemsController < ApplicationController
  def index
    invoice_item = InvoiceItem.find(params[:invoice_item_id])
    render json: ItemSerializer.new(invoice_item.items)
  end
end
