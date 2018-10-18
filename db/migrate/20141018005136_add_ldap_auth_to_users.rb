class AddLdapAuthToUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :ldap_auth, :boolean, default: false
  end
end
