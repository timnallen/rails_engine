class Api::V1::Invoices::CustomersController < ApplicationController
  def show
    invoice = Invoice.find(params[:invoice_id])
    render json: CustomerSerializer.new(invoice.customer)
  end
end
