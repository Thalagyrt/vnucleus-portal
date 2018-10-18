class AddAuthorizedAndAuthorizationCodeToKnownIpAddresses < ActiveRecord::Migration
  def change
    add_column :users_known_ip_addresses, :authorized, :boolean, default: false
    add_column :users_known_ip_addresses, :authorization_code, :string

    add_index :users_known_ip_addresses, :authorized

    execute "UPDATE users_known_ip_addresses SET authorized='t'"
  end
end
