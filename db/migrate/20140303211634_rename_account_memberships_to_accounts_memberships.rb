class RenameAccountMembershipsToAccountsMemberships < ActiveRecord::Migration
  def up
    rename_table :account_memberships, :accounts_memberships
  end

  def down
    rename_table :accounts_memberships, :account_memberships
  end
end
