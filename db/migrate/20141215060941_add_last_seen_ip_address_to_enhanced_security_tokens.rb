class AddLastSeenIpAddressToEnhancedSecurityTokens < ActiveRecord::Migration
  def change
    add_column :users_enhanced_security_tokens, :last_seen_ip_address, :string
  end
end
