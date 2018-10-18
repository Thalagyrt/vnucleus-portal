class CreateAccountPayments < ActiveRecord::Migration
  def change
    create_table :account_payments do |t|
      t.integer :account_id
      t.integer :amount
      t.string :reference
      t.string :last_4
      t.string :card_type
      t.datetime :created_at
    end

    add_index :account_payments, :account_id
  end
end
