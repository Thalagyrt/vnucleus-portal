class AddDatesToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :created_at, :datetime
    add_column :solus_servers, :updated_at, :datetime
  end
end
