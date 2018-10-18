class AddLongIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts_accounts, :long_id, :string
    add_index :accounts_accounts, :long_id, unique: true

    reversible do |dir|
      dir.up do
        Accounts::Account.find_each do |account|
          account.update_attribute :long_id, StringGenerator.long_id
        end
      end
    end
  end
end
