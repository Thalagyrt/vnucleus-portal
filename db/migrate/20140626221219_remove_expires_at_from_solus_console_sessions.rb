class RemoveExpiresAtFromSolusConsoleSessions < ActiveRecord::Migration
  def change
    remove_column :solus_console_sessions, :expires_at
  end
end
