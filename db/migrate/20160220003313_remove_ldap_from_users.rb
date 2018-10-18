class RemoveLdapFromUsers < ActiveRecord::Migration
  def change
    remove_column :users_users, :ldap_auth
  end
end
