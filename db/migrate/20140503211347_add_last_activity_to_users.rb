class AddLastActivityToUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :active_at, :datetime
    add_index :users_users, :active_at
  end
end
