class CreateAccountDebits < ActiveRecord::Migration
  def change
    create_table :account_debits do |t|
      t.integer :account_id
      t.integer :amount
      t.string :description
      t.datetime :created_at
    end

    add_index :account_debits, :account_id
  end
end
