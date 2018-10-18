class ChangeTransactionsAmountToDecimal < ActiveRecord::Migration
  def up
    change_column :transactions, :amount, :decimal, precision: 10, scale: 2
    execute "update transactions set amount=amount/100.0;"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
