class AddConsoleLockToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :console_locked_until, :datetime
    add_column :solus_servers, :console_locked_by_id, :integer
    add_column :solus_servers, :console_lock_id, :string
  end
end
