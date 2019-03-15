class Api::V1::TransactionsController < ApplicationController
  def index
    invoice = Invoice.find(params[:invoice_id])
    render json: TransactionSerializer.new(invoice.transactions)
  end
end
