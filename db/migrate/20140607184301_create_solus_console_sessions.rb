class CreateSolusConsoleSessions < ActiveRecord::Migration
  def change
    create_table :solus_console_sessions do |t|
      t.datetime :created_at
      t.datetime :expires_at
      t.string :ip_address
      t.string :target_hostname
      t.integer :target_port
    end

    add_index :solus_console_sessions, :ip_address, unique: true
    add_index :solus_console_sessions, :created_at
  end
end
