class CreateAccountCredits < ActiveRecord::Migration
  def change
    create_table :account_credits do |t|
      t.integer :account_id
      t.integer :amount
      t.string :description
      t.datetime :created_at
    end

    add_index :account_credits, :account_id
  end
end
