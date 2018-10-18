class RemoveTokenFromAccountsInvites < ActiveRecord::Migration
  def change
    remove_index :accounts_invites, :token
    remove_column :accounts_invites, :token
  end
end
