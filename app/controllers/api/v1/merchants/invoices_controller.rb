class Api::V1::Merchants::InvoicesController < ApplicationController
  def show
    merchant = Merchant.find(params[:merchant_id])
    render json: InvoiceSerializer.new(merchant.invoices)
  end
end
