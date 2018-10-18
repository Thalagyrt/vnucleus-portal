class CleanOutEnhancedSecurityTokens < ActiveRecord::Migration
  def change
    execute 'DELETE FROM users_enhanced_security_tokens'
  end
end
