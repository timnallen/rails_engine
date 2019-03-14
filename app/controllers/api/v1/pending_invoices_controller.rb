class Api::V1::PendingInvoicesController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: CustomerSerializer.new(merchant.customers_with_pending_invoices)
  end
end
