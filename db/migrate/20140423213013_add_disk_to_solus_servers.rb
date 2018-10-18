class AddDiskToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :disk, :bigint, default: 0
  end
end
