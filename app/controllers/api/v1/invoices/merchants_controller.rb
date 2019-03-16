class Api::V1::Invoices::MerchantsController < ApplicationController
  def show
    invoice = Invoice.find(params[:invoice_id])
    render json: MerchantSerializer.new(invoice.merchant)
  end
end
