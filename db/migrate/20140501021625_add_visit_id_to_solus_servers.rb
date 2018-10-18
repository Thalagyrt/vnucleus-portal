class AddVisitIdToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :visit_id, :integer
    add_index :solus_servers, :visit_id
  end
end
