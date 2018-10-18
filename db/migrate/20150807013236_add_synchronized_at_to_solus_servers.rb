class AddSynchronizedAtToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :synchronized_at, :datetime
  end
end
