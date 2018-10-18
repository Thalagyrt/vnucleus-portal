class AddWelcomeStateToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :welcome_state, :string

    reversible do |dir|
      dir.up do
        execute "UPDATE accounts_accounts SET welcome_state='complete'"
      end
    end
  end
end
