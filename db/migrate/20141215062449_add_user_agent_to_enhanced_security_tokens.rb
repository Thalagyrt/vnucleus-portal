class AddUserAgentToEnhancedSecurityTokens < ActiveRecord::Migration
  def change
    add_column :users_enhanced_security_tokens, :user_agent, :string
  end
end
