class Api::V1::InvoicesController < ApplicationController
  def index
    object = related_object_finder(params)
    render json: InvoiceSerializer.new(object.invoices)
  end

  def show
    object = related_object_finder(params)
    render json: InvoiceSerializer.new(object.invoice)
  end
end
