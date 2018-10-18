class AddAccountToUsages < ActiveRecord::Migration
  def change
    add_column :licenses_usages, :account_id, :integer
    add_index :licenses_usages, :account_id
  end
end
