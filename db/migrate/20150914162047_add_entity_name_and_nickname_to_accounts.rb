class AddEntityNameAndNicknameToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :entity_name, :string
    add_column :accounts_accounts, :nickname, :string

    execute 'UPDATE accounts_accounts SET entity_name=name'
  end
end
