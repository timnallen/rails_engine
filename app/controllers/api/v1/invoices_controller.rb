class Api::V1::InvoicesController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: InvoiceSerializer.new(merchant.invoices)
  end

  def show
    object = related_object_finder(params)
    render json: InvoiceSerializer.new(object.invoice)
  end
end
