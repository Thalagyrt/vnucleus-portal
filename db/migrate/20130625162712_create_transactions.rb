class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :amount
      t.integer :fee
      t.string :reference
      t.string :description
      t.datetime :created_at
    end

    add_index :transactions, :user_id
  end
end
