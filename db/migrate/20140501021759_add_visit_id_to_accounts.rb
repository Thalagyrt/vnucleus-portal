class AddVisitIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :visit_id, :integer
    add_index :accounts_accounts, :visit_id
  end
end
