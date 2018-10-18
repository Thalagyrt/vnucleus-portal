class AddNextDueToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :next_due, :date
    execute "UPDATE accounts_accounts SET next_due='#{Time.zone.today.next_month.at_beginning_of_month}'"
  end
end
