class AddKnownIpAuthorizationToUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :known_ip_address_authorization, :boolean, default: true
  end
end
