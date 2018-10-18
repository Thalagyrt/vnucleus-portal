class RemoveRolesFromAccountUsers < ActiveRecord::Migration
  def up
    remove_column :account_users, :roles
  end

  def down
    add_column :account_users, :roles, :integer
  end
end
