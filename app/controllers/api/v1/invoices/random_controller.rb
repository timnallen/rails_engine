class Api::V1::Invoices::RandomController < ApplicationController
  def show
    render json: InvoiceSerializer.new(Invoice.order(Arel.sql("RANDOM()")).limit(1).first)
  end
end
