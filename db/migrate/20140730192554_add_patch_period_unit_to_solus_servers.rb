class AddPatchPeriodUnitToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :patch_period_unit, :string
  end
end
