class AddPatchOutOfBandToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :patch_out_of_band, :boolean, default: false
    add_index :solus_servers, :patch_out_of_band
  end
end
