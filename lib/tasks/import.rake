namespace :import do
  desc "Import merchants from CSV file"
  task merchants: :environment do
    CSV.foreach('./lib/merchants.csv', headers: true) do |row|
      Merchant.create(row.to_h)
    end
    puts "Merchants imported!"
  end

  desc "Import customers from CSV file"
  task customers: :environment do
    CSV.foreach('./lib/customers.csv', headers: true) do |row|
      Customer.create(row.to_h)
    end
    puts "Customers imported!"
  end

  desc "Import invoice items from CSV file"
  task invoice_items: :environment do
    CSV.foreach('./lib/invoice_items.csv', headers: true) do |row|
      InvoiceItem.create(row.to_h)
    end
    puts "Invoice_items imported!"
  end

  desc "Import items from CSV file"
  task items: :environment do
    CSV.foreach('./lib/items.csv', headers: true) do |row|
      Item.create(row.to_h)
    end
    puts "Items imported!"
  end

  desc "Import invoices from CSV file"
  task invoices: :environment do
    CSV.foreach('./lib/invoices.csv', headers: true) do |row|
      Invoice.create(row.to_h)
    end
    puts "Invoices imported!"
  end

  desc "Import transactions from CSV file"
  task transactions: :environment do
    CSV.foreach('./lib/transactions.csv', headers: true) do |row|
      Transaction.create(row.to_h)
    end
    puts "Transactions imported!"
  end
end
