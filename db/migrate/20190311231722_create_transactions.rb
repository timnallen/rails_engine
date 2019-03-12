class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :credit_card_number
      t.string :credit_card_expiration_date
      t.string :result
      t.references :invoice, foreign_key: true

      t.string :created_at
      t.string :updated_at
    end
  end
end
