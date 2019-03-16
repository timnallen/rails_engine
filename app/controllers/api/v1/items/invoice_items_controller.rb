class Api::V1::Items::InvoiceItemsController < ApplicationController
  def index
    object = related_object_finder(params)
    render json: InvoiceItemSerializer.new(object.invoice_items)
  end
end
