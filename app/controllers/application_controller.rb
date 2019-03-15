class ApplicationController < ActionController::API
  def related_object_finder(params)
    if params[:merchant_id]
      Merchant.find(params[:merchant_id])
    elsif params[:invoice_id]
      Invoice.find(params[:invoice_id])
    elsif params[:invoice_item_id]
      InvoiceItem.find(params[:invoice_item_id])
    elsif params[:item_id]
      Item.find(params[:item_id])
    elsif params[:transaction_id]
      Transaction.find(params[:transaction_id])
    elsif params[:customer_id]
      Customer.find(params[:customer_id])
    end
  end
end
