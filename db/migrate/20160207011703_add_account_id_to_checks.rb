class AddAccountIdToChecks < ActiveRecord::Migration
  def change
    add_column :monitoring_checks, :account_id, :integer
    add_index :monitoring_checks, :account_id
  end
end
