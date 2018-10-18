class AddIndexOnReferrerId < ActiveRecord::Migration
  def change
    add_index :accounts_accounts, :referrer_id
  end
end
