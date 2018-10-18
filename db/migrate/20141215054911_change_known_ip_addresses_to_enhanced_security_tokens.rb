class ChangeKnownIpAddressesToEnhancedSecurityTokens < ActiveRecord::Migration
  def change
    rename_table :users_known_ip_addresses, :users_enhanced_security_tokens
    rename_column :users_enhanced_security_tokens, :ip_address, :token
  end
end
