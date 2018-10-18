class IndexUsersOnProfileComplete < ActiveRecord::Migration
  def change
    add_index :users_users, :profile_complete
  end
end
