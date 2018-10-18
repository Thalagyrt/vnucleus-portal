class EnableAffiliates < ActiveRecord::Migration
  def up
    change_column_default :accounts_accounts, :affiliate_enabled, :true
    Accounts::Account.update_all affiliate_enabled: true
  end

  def down
    change_column_default :accounts_accounts, :affiliate_enabled, :false
  end
end
