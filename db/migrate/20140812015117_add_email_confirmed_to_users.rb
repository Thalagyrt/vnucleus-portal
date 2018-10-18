class AddEmailConfirmedToUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :email_confirmed, :boolean, default: false
    Users::User.update_all email_confirmed: true
  end
end
