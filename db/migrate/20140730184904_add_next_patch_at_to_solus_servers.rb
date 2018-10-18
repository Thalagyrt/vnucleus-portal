class AddNextPatchAtToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :next_patch, :date
    add_index :solus_servers, :next_patch
  end
end
