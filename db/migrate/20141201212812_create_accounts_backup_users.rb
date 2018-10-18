class CreateAccountsBackupUsers < ActiveRecord::Migration
  def change
    create_table :accounts_backup_users do |t|
      t.integer :account_id
      t.string :username
      t.string :password
      t.string :login_url
    end

    add_index :accounts_backup_users, :account_id
  end
end
