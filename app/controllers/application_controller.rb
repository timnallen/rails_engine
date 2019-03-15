class ApplicationController < ActionController::API
  def related_object_finder(params)
    if params[:merchant_id]
      Merchant.find(params[:merchant_id])
    elsif params[:invoice_id]
      Invoice.find(params[:invoice_id])
    elsif params[:invoice_item_id]
      InvoiceItem.find(params[:invoice_item_id])
    end
  end
end
