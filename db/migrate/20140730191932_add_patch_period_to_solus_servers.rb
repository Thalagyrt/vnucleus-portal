class AddPatchPeriodToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :patch_period, :integer
  end
end
