class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.string :account_type
      t.string :routing_number
      t.string :account_number
      t.integer :amount
      t.string :individual_id_number
      t.string :individual_name
      t.string :confirmation_number
      t.string :transaction_status
      t.references :batch, index: true

      t.timestamps
    end
  end
end
