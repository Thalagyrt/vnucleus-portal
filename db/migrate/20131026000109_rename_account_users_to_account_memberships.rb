class RenameAccountUsersToAccountMemberships < ActiveRecord::Migration
  def change
    rename_table :account_users, :account_memberships
  end
end
