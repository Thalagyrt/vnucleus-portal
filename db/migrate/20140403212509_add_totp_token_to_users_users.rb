class AddTotpTokenToUsersUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :totp_token, :string
  end
end
