class AddPatchPagerdutyIncidentIdToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :patch_incident_key, :string
  end
end
