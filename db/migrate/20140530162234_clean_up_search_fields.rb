class CleanUpSearchFields < ActiveRecord::Migration
  def change
    remove_column :users_users, :full_name
    remove_column :visits, :utm_data
  end
end
