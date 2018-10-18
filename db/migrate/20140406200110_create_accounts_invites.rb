class CreateAccountsInvites < ActiveRecord::Migration
  def change
    create_table :accounts_invites do |t|
      t.integer :account_id
      t.string :email
      t.string :token
      t.integer :roles_mask
      t.datetime :created_at
    end

    add_index :accounts_invites, :account_id
    add_index :accounts_invites, :token, unique: true
    add_index :accounts_invites, :created_at
  end
end
