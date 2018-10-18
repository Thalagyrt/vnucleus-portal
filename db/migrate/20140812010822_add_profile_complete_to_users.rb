class AddProfileCompleteToUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :profile_complete, :boolean, default: false
    Users::User.update_all profile_complete: true
  end
end
