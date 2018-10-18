class CreateAccountsNotes < ActiveRecord::Migration
  def change
    create_table :accounts_notes do |t|
      t.text :body
      t.integer :user_id
      t.integer :account_id
      t.integer :created_at
    end

    add_index :accounts_notes, :user_id
    add_index :accounts_notes, :account_id
    add_index :accounts_notes, :created_at
  end
end
