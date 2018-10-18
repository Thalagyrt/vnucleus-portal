class AddClassToTransactions < ActiveRecord::Migration
  def up
    add_column :account_transactions, :category, :string
    add_index :account_transactions, :category

    execute "UPDATE account_transactions SET category='debit' WHERE reference LIKE 'db_%'"
    execute "UPDATE account_transactions SET category='credit' WHERE reference LIKE 'cr_%'"
    execute "UPDATE account_transactions SET category='payment' WHERE reference LIKE 'ch_%'"
  end

  def down
    remove_index :account_transactions, :category
    remove_column :account_transactions, :category
  end
end
