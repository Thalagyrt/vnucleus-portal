class AddUsedTransferToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :used_transfer, :bigint
    add_index :solus_servers, :used_transfer
  end
end
