class Api::V1::InvoiceItems::RandomController < ApplicationController
  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.order(Arel.sql("RANDOM()")).limit(1).first)
  end
end
