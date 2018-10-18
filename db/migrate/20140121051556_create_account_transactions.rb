class CreateAccountTransactions < ActiveRecord::Migration
  def change
    create_table :account_transactions do |t|
      t.integer :account_id
      t.integer :amount
      t.integer :fee
      t.string :reference
      t.string :description
      t.datetime :created_at
    end

    add_index :account_transactions, :account_id
  end
end
