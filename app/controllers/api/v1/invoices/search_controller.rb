class Api::V1::Invoices::SearchController < ApplicationController
  def index
    render json: InvoiceSerializer.new(Invoice.where(invoice_params))
  end

  def show
    render json: InvoiceSerializer.new(Invoice.find_by(invoice_params))
  end

  private

  def invoice_params
    params.permit(:id, :name, :status, :merchant, :customer, :created_at, :updated_at)
  end
end
