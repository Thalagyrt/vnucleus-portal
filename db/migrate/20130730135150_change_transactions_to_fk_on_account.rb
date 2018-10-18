class ChangeTransactionsToFkOnAccount < ActiveRecord::Migration
  def change
    remove_index :transactions, :user_id
    remove_column :transactions, :user_id

    add_column :transactions, :account_id, :integer
    add_index :transactions, :account_id
  end
end
