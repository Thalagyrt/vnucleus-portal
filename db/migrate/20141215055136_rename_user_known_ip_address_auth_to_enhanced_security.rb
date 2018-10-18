class RenameUserKnownIpAddressAuthToEnhancedSecurity < ActiveRecord::Migration
  def change
    rename_column :users_users, :known_ip_address_authorization, :enhanced_security
  end
end
