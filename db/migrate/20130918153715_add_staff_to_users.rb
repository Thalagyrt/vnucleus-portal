class AddStaffToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_staff, :boolean
    add_index :users, :is_staff
  end
end
