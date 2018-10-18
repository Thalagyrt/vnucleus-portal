class RenameUsersToUsersUsers < ActiveRecord::Migration
  def up
    rename_table :users, :users_users
  end

  def down
    rename_table :users_users, :users
  end
end
