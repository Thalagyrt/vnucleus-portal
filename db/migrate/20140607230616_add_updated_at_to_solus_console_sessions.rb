class AddUpdatedAtToSolusConsoleSessions < ActiveRecord::Migration
  def change
    add_column :solus_console_sessions, :updated_at, :datetime
    add_index :solus_console_sessions, :updated_at

    execute 'UPDATE solus_console_sessions SET updated_at=created_at'
  end
end
