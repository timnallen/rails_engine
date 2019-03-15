class ApplicationController < ActionController::API
  def object_finder(params)
    if params[:merchant_id]
      Merchant.find(params[:merchant_id])
    elsif params[:invoice_id]
      Invoice.find(params[:invoice_id])
    end
  end
end
