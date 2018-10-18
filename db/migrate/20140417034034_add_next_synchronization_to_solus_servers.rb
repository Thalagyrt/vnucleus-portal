class AddNextSynchronizationToSolusServers < ActiveRecord::Migration
  def up
    add_column :solus_servers, :synchronize_at, :datetime
    execute "update solus_servers set synchronize_at='#{Time.zone.now}'"
  end

  def down
    remove_column :solus_servers, :synchronize_at
  end
end
