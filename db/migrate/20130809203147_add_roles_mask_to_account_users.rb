class AddRolesMaskToAccountUsers < ActiveRecord::Migration
  def change
    add_column :account_users, :roles_mask, :integer
  end
end
